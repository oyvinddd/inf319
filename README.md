# Food Delivery Logistics Platform

# Introduction

A platform where restaurants and transportation companies can sign up and together provide a food delivery service to end users. The platform handles all the logistics related to picking up and delivering the food. The main interface for the end users comes in the form of a mobile app, where users can browse restaurants and place orders.

# Scope

## Platform

The logistics platform is the main focus of the project. Its purpose is to assign orders to transportation personell, calculate routes, generate time-limited deals, as well as expose a clean REST API for the mobile app to use.

Additionally, the platform should make use of a recommendation engine that should be used for recommending restaurants to users.

### Technical Details

The majority of the platform will be implemented in Go (v1.15), but some special parts *might* make use of other technologies such as Python or C/C++ (if needed). The recommendation engine is not to be implemented from scratch, and as such, an existing library will be used for this part.

Test data will most likely be hard coded, but if it turns out that a database is needed, PostgreSQL will be used.

Furthermore, the platform will *most likely* make use of some functionality in the Google Maps API. The platform will be hosted on a free tier on either [Heroku](https://www.heroku.com/) or [GCP](https://console.cloud.google.com/).

## iOS App

A fully-functioning iOS app will be made as part of the project scope. Since the app is not the main focus of the project it will be kept relatively simple with just a couple of screens. The main focus of the app is to consume a REST API exposed by the logistics platform and display this information to the end user. As a minimum, the app should show a list of nearby recommended restaurants as well as any available time limited deals.

### Technical Details

The mobile app will be a native iOS app written in Swift 5. Geocoding/device GPS will be used to show recommended restaurants nearby. Push notifications *might* be used for notifying users of special time limited deals.
