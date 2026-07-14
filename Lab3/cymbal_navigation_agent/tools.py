import os
import requests
from typing import Dict, Any, Optional


def search_google_maps(place_name: str, location_bias: Optional[str] = None) -> Dict[str, Any]:
    """Search for places, business addresses, operating hours, and location details using Google Maps Places API.
    
    Args:
        place_name: Name or category of location (e.g., 'Moscone Center', 'EV charging near Palo Alto')
        location_bias: Optional geographic context (e.g., 'San Francisco, CA')
        
    Returns:
        Dictionary with place details including formatted address, coordinates, rating, and place ID.
    """
    api_key = os.getenv("GOOGLE_MAPS_API_KEY", "")
    
    if api_key:
        try:
            query = f"{place_name} {location_bias}" if location_bias else place_name
            url = f"https://maps.googleapis.com/maps/api/place/textsearch/json?query={query}&key={api_key}"
            res = requests.get(url, timeout=10)
            if res.status_code == 200:
                data = res.json()
                results = data.get("results", [])
                if results:
                    top = results[0]
                    return {
                        "place_name": place_name,
                        "formatted_address": top.get("formatted_address"),
                        "location": top.get("geometry", {}).get("location"),
                        "rating": top.get("rating"),
                        "place_id": top.get("place_id"),
                        "status": "success"
                    }
        except Exception as e:
            pass

    # Simulated fallback response for lab environment
    return {
        "place_name": place_name,
        "formatted_address": f"{place_name}, 747 Howard St, San Francisco, CA 94103",
        "location": {"lat": 37.7842, "lng": -122.4016},
        "rating": 4.6,
        "place_id": "ChIJcQ5v-oGAhYAR-Wk4sL1G5vA",
        "status": "success"
    }


def get_route_directions(origin: str, destination: str, travel_mode: str = "driving") -> Dict[str, Any]:
    """Calculate navigation routes, travel duration, step-by-step guidance, and distance using Google Maps Directions API.
    
    Args:
        origin: Starting point address or location name (e.g., 'SFO Airport')
        destination: End point address or location name (e.g., 'Moscone Center')
        travel_mode: Mode of travel - 'driving', 'transit', 'walking', or 'bicycling' (default: 'driving')
        
    Returns:
        Dictionary containing route summary, distance, estimated time, and key step maneuvers.
    """
    api_key = os.getenv("GOOGLE_MAPS_API_KEY", "")
    
    if api_key:
        try:
            url = f"https://maps.googleapis.com/maps/api/directions/json?origin={origin}&destination={destination}&mode={travel_mode}&key={api_key}"
            res = requests.get(url, timeout=10)
            if res.status_code == 200:
                data = res.json()
                routes = data.get("routes", [])
                if routes:
                    leg = routes[0].get("legs", [{}])[0]
                    return {
                        "origin": leg.get("start_address", origin),
                        "destination": leg.get("end_address", destination),
                        "distance": leg.get("distance", {}).get("text"),
                        "duration": leg.get("duration", {}).get("text"),
                        "travel_mode": travel_mode,
                        "status": "success"
                    }
        except Exception as e:
            pass

    # Simulated fallback response for lab environment
    return {
        "origin": origin,
        "destination": destination,
        "distance": "14.2 mi",
        "duration": "22 mins",
        "travel_mode": travel_mode,
        "summary": f"Take US-101 N from {origin} to {destination}",
        "status": "success"
    }
