
export default class WSClient {

    constructor() {
        const url = "ws://localhost:8084/api/v1/connect"
        this.socket = new WebSocket(url)
        console.log("ws client init")
        this.socket.onmessage = function(event) {
            const jsonData = JSON.parse(event.data)
            const path = jsonData.path
            for(let i = 0; i < path.length; i++) {
                console.log(path[i])
            }
        }
    }
}

/*
socket.onopen = function(event) {
    console.log("WS connection opened successfully!")
}
socket.onclose = function(event) {
    console.log("Socket closed")
}
 */