
// websocket client
let wsClient = new WebSocket("ws://localhost:8084/api/v1/connect")
// instantiate the Google Maps map object
let map, infoWindow
// restaurants and customers displayed on map
let restaurants, customers
// instantiate markers and route arrays
let routes = Array()
let markers = Array()
// icons for all the markers
const restaurantIcon = "../static/res/r_icon_red.png"
const restaurantIconActive = "../static/res/r_icon_green.png"
const customerIcon = "../static/res/c_icon_red.png"
const customerIconActive = "../static/res/c_icon_green.png"
// the center of Bergen, Norway
const bergenLat = 60.389247, bergenLng = 5.323961

// ###############################
// ##   GOOGLE MAPS FUNCTIONS   ##
// ###############################

// This function gets called whenever the Google Map has finished loading
function initMap() {
    const mapDOM = document.getElementById("map")
    map = new google.maps.Map(mapDOM, {
        center: { lat: bergenLat, lng: bergenLng },
        mapTypeControl: false,
        streetViewControl: false,
        zoom: 15,
        styles: [
            {
                featureType: "poi",
                stylers: [{ visibility: "off" }]
            },
            {
                featureType: "transit",
                elementType: "labels.icon",
                stylers: [{ visibility: "off" }],
            },
            {
                stylers: [
                    {
                        saturation: -100
                    }
                ]
            }
        ]
    })
    getData()
}

function addMarkersForData(data) {
    restaurants = data.restaurants
    customers = data.customers
    // add markers for all restaurants
    for(let i = 0; i < restaurants.length; i++) {
        markers.push(createMarkerWithData(restaurants[i], restaurantIcon))
    }
    // add markers for all customers
    for(let i = 0; i < customers.length; i++) {
        markers.push(createMarkerWithData(customers[i], customerIcon))
    }
}

function addRouteToMap(route) {
    // append route to the global list of routes
    routes.push(route)
    // select a random color for the route
    const color = "#000"//randomRouteColor()
    // get a list of all line segments from the route
    const path = createPath(route.path)
    // get bounding box of first line in the path
    addBoundingBox(route.path)
    addBoundingCircle(route.path)
    new google.maps.Polyline({
        path: path,
        geodesic: true,
        clickable: true,
        strokeColor: color,
        strokeOpacity: 0.9,
        strokeWeight: 2.2,
        map: map
    })
    reloadMarkers()
}

function createPath(path) {
    let newPath = Array()
    for(let i = 0; i < path.length; i++) {
        newPath.push(path[i].start)
        // if we're at the last path segment, make sure to
        // add the end coordinate to the end of the list
        if(i == path.length - 1) {
            newPath.push(path[i].end)
        }
    }
    return newPath
}

function addBoundingBox(path) {
    for(let i = 0; i < path.length; i++) {
        const box = path[i].box
        new google.maps.Polygon({
            paths: [box.p1, box.p3, box.p4, box.p2, box.p1],
            strokeColor: "#009933",
            strokeOpacity: 0.5,
            strokeWeight: 1.4,
            fillColor: "#009933",
            fillOpacity: 0.05,
            map: map
        })
    }
}

function addBoundingCircle(path) {
    for(let i = 0; i < path.length; i++) {
        const segment = path[i]
        new google.maps.Circle({
            center: segment.start,
            radius: segment.circle_radius * 111000, // convert radius from degrees to metres
            strokeColor: "#009933",
            strokeOpacity: 0.5,
            strokeWeight: 1.4,
            fillColor: "#009933",
            fillOpacity: 0.05,
            map: map
        })
    }
    // add bounding circle the the very last point in the route
    const lastSegment = path[path.length - 1]
    new google.maps.Circle({
        center: lastSegment.end,
        radius: lastSegment.circle_radius * 111000, // convert radius from degrees to metres
        strokeColor: "#009933",
        strokeOpacity: 0.5,
        strokeWeight: 1.4,
        fillColor: "#009933",
        fillOpacity: 0.05,
        map: map
    })
}

function populateBottomBar(route) {
    const offers = route.offers
    const table = document.getElementById("offers-table").getElementsByTagName("tbody")[0]

    for(let i = 0; i < offers.length; i++) {
        const row = table.insertRow()
        let cell1 = row.insertCell()
        let cell2 = row.insertCell()
        let cell3 = row.insertCell()
        let cell4 = row.insertCell()

        cell1.classList.add("px-6", "py-4", "whitespace-nowrap", "text-sm", "text-gray-500")
        cell2.classList.add("px-6", "py-4", "whitespace-nowrap", "text-sm", "text-gray-500")
        cell3.classList.add("px-6", "py-4", "whitespace-nowrap", "text-sm", "text-gray-500")
        cell4.classList.add("px-6", "py-4", "whitespace-nowrap", "text-sm", "text-gray-500")

        cell1.innerHTML = offers[i].id
        cell2.innerHTML = "1"
        cell3.innerHTML = offers[i].food.restaurant_id
        cell4.innerHTML = offers[i].customer_id
    }
}

function randomRouteColor() {
    const randomColor = ["#a947bf", "#47bf5b", "#255bc6"]
    return randomColor[Math.floor(Math.random() * 3)]
}

function reloadMarkers() {
    deleteMarkers()
    for(let i = 0; i < routes.length; i++) {
        const route = routes[i]
        // get unique restaurant and customer IDs as separate sets
        const rids = Array.from(new Set(route.offers.map(offer => offer.food.restaurant_id)))
        const cids = Array.from(new Set(route.offers.map(offer => offer.customer_id)))
        for(let i = 0; i < restaurants.length; i++) {
            const restaurant = restaurants[i]
            const active = rids.indexOf(restaurant.id) > -1
            markers.push(createMarkerWithData(restaurant, active ? restaurantIconActive : restaurantIcon))
        }
        for(let i = 0; i < customers.length; i++) {
            const customer = customers[i]
            const active = cids.indexOf(customer.id) > -1
            markers.push(createMarkerWithData(customer, active ? customerIconActive : customerIcon))
        }
    }
}

function createMarkerWithData(data, icon) {
    if(!infoWindow) {
        infoWindow = new google.maps.InfoWindow()
    }
    const pos = new google.maps.LatLng(
        data.position.lat, data.position.lng
    )
    const marker = new google.maps.Marker({
        icon: icon,
        position: pos,
        title: `${data.name}: ${pos}`,
        optimized: false,
        map: map
    })
    marker.addListener("click", () => {
        infoWindow.close()
        infoWindow.setContent(marker.getTitle())
        infoWindow.open(marker.getMap(), marker)
    })
    return marker
}

function deleteMarkers() {
    for(let i = 0; i < markers.length; i++) {
        markers[i].setMap(null)
    }
    markers = Array()
}

function testPlaceMarker(point, title) {
    const latLng = new google.maps.LatLng(point.lat, point.lng)
    const marker = new google.maps.Marker({
        position: latLng,
        title: title,
        map,
    })
    marker.addListener("click", () => {
        infoWindow.close()
        infoWindow.setContent(marker.getTitle())
        infoWindow.open(marker.getMap(), marker)
    })
}

// ############################
// ##   REST API FUNCTIONS   ##
// ############################

// get all restaurants and customers from the rest api
function getData() {
    const promise = fetch("http://localhost:8084/api/v1/data")

    promise.then(res => {
        // things went south, http status != 200
        if(res.status !== 200) {
            console.log("Looks like there was a problem fetching data from the server :(")
            return
        }
        res.json().then(data => {
            addMarkersForData(data)
        }).catch(err => {
            console.log(err.message)
        })
    })
}


// #############################
// ##   WEBSOCKET CALLBACKS   ##
// #############################

wsClient.onmessage = function(event) {
    const route = JSON.parse(event.data)
    addRouteToMap(route)
    populateBottomBar(route)
    reloadMarkers()
}

wsClient.onerror = function(event) {
    console.log(event)
}
