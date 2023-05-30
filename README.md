# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Zombie SNS API Documentation

This documentation provides information about the RESTful API endpoints for the Zombie SNS application.

Endpoints
1. Sign up a survivor
  <code>
    URL: http://localhost:3000/api/survivors
    Method: POST
    Description: Creates a new survivor and adds them to the database.
    Request Body:
    {
      "name": "John Doe",
      "age": 25,
      "gender": "Male",
      "latitude": 76,
      "longitude": 120.34,
      "survivor_inventory_items_attributes": [
        { "inventory_item_id": 4, "quantity": 5 },
        { "inventory_item_id": 2, "quantity": 3 },
        { "inventory_item_id": 3, "quantity": 2 }
      ]
    }
    Response Body:
    {
      "id": 20,
      "name": "John Doe",
      "age": 25,
      "gender": "Male",
      "latitude": 76.0,
      "longitude": 120.34,
      "reported_by": [],
      "survivor_inventory_items": [
        { "id": 4, "inventory_item_id": 4, "quantity": 5 },
        { "id": 5, "inventory_item_id": 2, "quantity": 3 },
        { "id": 6, "inventory_item_id": 3, "quantity": 2 }
      ]
    }
  </code>

2. Update survivor location
  <code>
    URL: http://localhost:3000/api/survivors/:id
    Method: PATCH
    Description: Updates the last known location of a survivor.
    Request Body:
    { "latitude": -45.54, "longitude": -129.4 }
    Response Body:
    {
      "id": 3,
      "name": "John Doe",
      "age": 25,
      "gender": "Male",
      "latitude": -45.54,
      "longitude": -129.4,
      "reported_by": [2],
      "survivor_inventory_items": []
    }
  </code>

3. Flag survivor as infected
  <code>
    URL: http://localhost:3000/api/survivors/:id/reported_infected_survivor
    Method: POST
    Description: Report a survivor as infected. If the report count is five or more, the reported survivor will be flagged as infected.
    Request Body:
    { "infected_user_id": 4 }
    Response Body:
    { "message": "Survivor is reported as infected" }
  </code>

4. Delete Survivor
  <code>
    URL: http://localhost:3000/api/survivors/:id
    Method: DELETE
    Description: Delete a Survivor
    Response Body:
    { "message": "Survivor is destroyed" }
  </code>

5. Get Survivors
  <code>
    URL: http://localhost:3000/api/survivors
    Method: GET
    Description: Get all survivors
    Response Body:
    [
      {
        "id": 5,
        "name": "John Doe",
        "age": 25,
        "gender": "Male",
        "latitude": 76.0,
        "longitude": 120.34,
        "reported_by": [],
        "survivor_inventory_items": []
      },
      {
        "id": 6,
        "name": "John Doe",
        "age": 25,
        "gender": "Male",
        "latitude": 76.0,
        "longitude": 120.34,
        "reported_by": [],
        "survivor_inventory_items": []
      },
      {
        "id": 8,
        "name": "John Doe",
        "age": 25,
        "gender": "Male",
        "latitude": 76.0,
        "longitude": 120.34,
        "reported_by": [],
        "survivor_inventory_items": []
      },
      {
        "id": 9,
        "name": "John Doe",
        "age": 25,
        "gender": "Male",
        "latitude": 76.0,
        "longitude": 120.34,
        "reported_by": [],
        "survivor_inventory_items": []
      },
      {
        "id": 3,
        "name": "John Doe",
        "age": 25,
        "gender": "Male",
        "latitude": -45.54,
        "longitude": -129.4,
        "reported_by": [2],
        "survivor_inventory_items": []
      },
      {
        "id": 10,
        "name": "John Doe",
        "age": 25,
        "gender": "Male",
        "latitude": 76.0,
        "longitude": 120.34,
        "reported_by": [],
        "survivor_inventory_items": []
      },
      {
        "id": 4,
        "name": "John Doe",
        "age": 25,
        "gender": "Male",
        "latitude": 76.0,
        "longitude": 120.34,
        "reported_by": [3],
        "survivor_inventory_items": []
      }
    ]
  </code>

6. Create items
  <code>
    URL: http://localhost:3000/api/items
    Method: POST
    Description: Create a new item and add it to the database.
    Request Body:
    { "inventory_item": { "name": "soup", "points": 12 } }
    Response Body:
    { "id": 2, "name": "soup", "points": 12 }
  </code>

7. Update item
  <code>
    URL: http://localhost:3000/api/items/:id
    Method: PATCH
    Description: Update the item.
    Request Body:
    { "inventory_item": { "name": "ak47", "points": 10 } }
    Response Body:
    { "id": 2, "name": "ak47", "points": 10 }
  </code>

8. Delete Item
  <code>
    URL: http://localhost:3000/api/items/:id
    Method: DELETE
    Description: Delete an item
    Response Body:
    { "message": "Item is destroyed" }
  </code>

9. Get Items
  <code>
    URL: http://localhost:3000/api/items
    Method: GET
    Description: Get all items
    Response Body:
    [
      { "id": 2, "name": "ak47", "points": 10 },
      { "id": 3, "name": "water", "points": 14 },
      { "id": 4, "name": "soup", "points": 12 }
    ]
  </code>

10. Trade items
  <code>
    URL: http://localhost:3000/api/items/trade
    Method: POST
    Description: Allow survivors to trade items with each other.
    Request Body:
    {
      "survivor1_id": 3,
      "survivor2_id": 4,
      "survivor1_items": [
        { "item_id": 1, "quantity": 3 },
        { "item_id": 4, "quantity": 2 }
      ],
      "survivor2_items": [
        { "item_id": 5, "quantity": 43 },
        { "item_id": 14, "quantity": 22 }
      ]
    }
    Response Body:
    { "message": "Trade successful" }
  </code>

11. Reports
  <code>
    URL: http://localhost:3000/api/reports/generate_report
    Method: GET
    Description: Retrieve various reports related to the survivors.
    Response Body:
    {
      "percentage": {
        "infected_survivors": 25.0,
        "non_infected_survivors": 75.0
      },
      "items": [
        { "item_name": "water", "avg_quantity": "25.5", "id": null },
        { "item_name": "ak47", "avg_quantity": "43.6", "id": null },
        { "item_name": "soup", "avg_quantity": "58.9", "id": null }
      ],
      "total_lost_points": 0
    }
  </code>
