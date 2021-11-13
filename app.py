from flask import Flask, render_template, request
import os
from flask.helpers import url_for

from flask.wrappers import Request
from werkzeug.utils import redirect
import database.db_connector as db


# Configuration

app = Flask(__name__)

# Connect to database when server is started
db_connection = db.connect_to_database()


# Routes 

@app.route('/')
def root():
    """Serves the website home page"""
    return render_template("index.html")

@app.route('/customers', methods=['GET', 'POST'])
def customers():
    """Serves the Customers page"""

    # Handle GET requests by fetching all Customers data
    if request.method == 'GET':
        query = "SELECT * FROM `Customers`;"
        customer_info = db.execute_query(db_connection, query).fetchall()

        return render_template("customers.html", customer_info=customer_info)

    # Handle POST requests by inserting form data from front end
    if request.method == 'POST':
        first_name = request.form['firstName']
        last_name = request.form['lastName']
        street_address = request.form['streetAddress']
        city = request.form['city']
        state = request.form['state']
        zip_code = request.form['zipCode']
        phone = request.form['phoneNumber']
        email = request.form['email']

        # Handle case when no phone number is given to ensure phoneNumber will be NULL in database
        if phone is None:
            query = "INSERT INTO `Customers` (`firstName`, `lastName`, `streetAddress`, `city`, `state`, `zipCode`, `email`) VALUES (%s, %s, %s, %s, %s, %s, %s);"
            data = (first_name, last_name, street_address, city, state, zip_code, email)
        else:
            query = "INSERT INTO `Customers` (`firstName`, `lastName`, `streetAddress`, `city`, `state`, `zipCode`, `phoneNumber`, `email`) VALUES (%s, %s, %s, %s, %s, %s, %s, %s);"
            data = (first_name, last_name, street_address, city, state, zip_code, phone, email)

        # Execute query to insert data
        db.execute_query(db_connection, query, data)
        print("Customer successfully added.")

        # Redirect to this webpage after form submission
        return redirect(url_for('customers'))
    

@app.route('/vinyls')
def vinyls():
    """Serves the Vinyls page"""

    # Sample data to fill first two rows on table
    vinyl_info = [{"product_id": 3, "album": "Back in Black", "artist": "AC/DC", "genre": "hard rock", "price": 21.67, "quantity_available": 23},
                  {"product_id": 5, "album": "The Dark Side of the Moon", "artist": "Pink Floyd/DC", "genre": "rock", "price": 18.99, "quantity_available": 29}]

    return render_template("vinyls.html", vinyl_info=vinyl_info)

@app.route('/orders')
def orders():
    """Serves the Orders page"""

    # Sample data to fill first two rows on table
    order_info = [{"order_id": 34, "order_date": "2021-10-21", "customer_id": 3, "coupon_id": "FALL_2021", "order_status": "in process"},
                  {"order_id": 37, "order_date": "2021-10-18", "customer_id": 5, "coupon_id": "NULL", "order_status": "delivered"}]

    return render_template("orders.html", order_info=order_info)

@app.route('/coupons')
def coupons():
    """Serves the Coupons Products page"""

    # Sample data to fill first two rows on table
    coupon_info = [{"coupon_id": "FALL_2021", "discount": 0.25, "expire_date": "2021-11-23"},
                   {"coupon_id": "FOOTOWN_SPECIAL", "discount": 0.15, "expire_date": "2021-10-31"}]

    return render_template("coupons.html", coupon_info=coupon_info)

@app.route('/orderProducts')
def order_products():
    """Serves the Order Products page"""

    # Sample data to fill first two rows on table
    order_prod_info = [{"order_id": 35, "product_id": 4, "quantity": 3},
                       {"order_id": 39, "product_id": 11, "quantity": 4}]

    return render_template("order-products.html", order_prod_info=order_prod_info)

# Listener
if __name__ == "__main__":
    port = int(os.environ.get('PORT', 8796)) 
    #                                 ^^^^
    #              You can replace this number with any valid port
    
    app.run(port=port, debug=True) 
