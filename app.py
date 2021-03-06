from flask import Flask, render_template, request
import os
from flask.helpers import flash, url_for
from werkzeug.utils import redirect
import database.db_connector as db
import MySQLdb


# Configuration
app = Flask(__name__)

# Connect to database when server is started
db_connection = db.connect_to_database()

# Reconnect to database to avoid database connection break
def execute_query(db_connection = None, query = None, query_params = ()):
    try:
        return db.execute_query(db_connection, query, query_params)
    except MySQLdb.OperationalError as error:
        if error.args[0] == 2006:
            db_connection = db.connect_to_database()
            return db.execute_query(db_connection, query, query_params)
        else:
            raise

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
        customer_info = execute_query(db_connection, query).fetchall()

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
        if phone == "":
            query = "INSERT INTO `Customers` (`firstName`, `lastName`, `streetAddress`, `city`, `state`, `zipCode`, `email`) VALUES (%s, %s, %s, %s, %s, %s, %s);"
            data = (first_name, last_name, street_address, city, state, zip_code, email)
        else:
            query = "INSERT INTO `Customers` (`firstName`, `lastName`, `streetAddress`, `city`, `state`, `zipCode`, `phoneNumber`, `email`) VALUES (%s, %s, %s, %s, %s, %s, %s, %s);"
            data = (first_name, last_name, street_address, city, state, zip_code, phone, email)

        # Execute query to insert data
        execute_query(db_connection, query, data)

        # Redirect to same webpage after form submission
        return redirect(url_for('customers'))
    

@app.route('/vinyls', methods=['GET', 'POST'])
def vinyls():
    """Serves the Vinyls page"""

    # Handle GET requests by fetching all Customers data
    if request.method == 'GET':
        query = "SELECT * FROM `Vinyls`;"
        vinyl_info = execute_query(db_connection, query).fetchall()
        return render_template("vinyls.html", vinyl_info=vinyl_info)

    # Handle POST requests by inserting form data from front end
    if request.method == 'POST':
        album_name = request.form['albumName']
        artist_name = request.form['artistName']
        genre = request.form['genre']
        price = request.form['price']
        quantity_available = request.form['quantityAvailable']
        
        query = "INSERT INTO `Vinyls` (`albumName`, `artistName`, `genre`, `price`, `quantityAvailable`) VALUES (%s, %s, %s, %s, %s);"
        data = (album_name, artist_name, genre, price, quantity_available)
        
        # Execute query to insert data
        execute_query(db_connection, query, data)
        
        # Redirect to same webpage after form submission
        return redirect(url_for('vinyls'))


@app.route('/orders', methods=['GET', 'POST'])
def orders():
    """Serves the Orders page"""

    # Handle GET requests by fetching all Orders data
    if request.method == 'GET':
        customer_filter = None  # customerID filter initialized to None
    
        # default query: select the entire table
        query_orders = "SELECT * FROM `Orders`;"

        # if there is no request parameter, skip to show the entire table
        if len(request.args) == 0:
            pass

        # Delete order by orderID
        elif request.args.get('order_to_delete') != None:
            order_to_delete = request.args['order_to_delete']
            query_delete_order = "DELETE FROM `Orders` WHERE `orderID` = " + order_to_delete + ";"
            execute_query(db_connection, query_delete_order)
        
        # If 'Clear Filter' option is chosen, refresh page with no filters
        elif request.args.get('customerID') == "":
            return redirect(url_for('orders'))

        # Otherwise select table with customerID filters applied
        elif request.args.get('customerID') != None:
            customer_filter = request.args['customerID']
            query_orders = "SELECT * FROM `Orders` WHERE customerID = " + customer_filter + ";"
            
        order_info = execute_query(db_connection, query_orders).fetchall()

        # Fetch all customerID's for drop down menu
        query_customers = "SELECT `customerID`, `firstName`, `lastName` FROM `Customers`;"
        customer_names = execute_query(db_connection, query_customers)

        # Fetch all couponID's for drop down menu
        query_coupons = "SELECT `couponID` FROM `Coupons`;"
        coupon_info = execute_query(db_connection, query_coupons)
        
        # Fetch all orderID's for drop down menu
        query_orderID = "SELECT `orderID` FROM `Orders` ORDER BY `orderID`;"
        orderID_info = execute_query(db_connection, query_orderID)
        return render_template("orders.html", order_info=order_info, customer_names=customer_names, coupon_info=coupon_info, orderID_info=orderID_info, filter=customer_filter)
    
    if request.method == 'POST':

        # If add an order
        if request.form.get('customerID') != None:
            order_date = request.form['orderDate']
            customer_id = request.form['customerID']
            coupon_id = request.form['couponID']
            order_status = request.form['orderStatus']
            
            # Handle case when no couponID is given
            if coupon_id == "":
                query = "INSERT INTO `Orders` (`orderDate`,`customerID`, `couponID`, `orderStatus`) VALUES (%s, %s, NULL, %s);"
                data = (order_date, customer_id, order_status)
            else:
                query = "INSERT INTO `Orders` (`orderDate`,`customerID`, `couponID`, `orderStatus`) VALUES (%s, %s, %s, %s);"
                data = (order_date, customer_id, coupon_id, order_status)
            
            # Execute query to insert data
            execute_query(db_connection, query, data)
        
        # If update an order
        if request.form.get('order_to_update') != None:
            order_to_update = request.form['order_to_update']
            orderStatus_to_update = request.form['orderStatus_to_update']
            coupon_to_update = request.form['coupon_to_update']
            
            # Handle case when no couponID is given
            if coupon_to_update == "":
                query = "UPDATE `Orders` SET `orderStatus` = %s, `couponID` = NULL WHERE `orderID` = %s;"
                data = (orderStatus_to_update, order_to_update)
            else:
                query = "UPDATE `Orders` SET `orderStatus` = %s, `couponID` = %s WHERE `orderID` = %s;"
                data = (orderStatus_to_update, coupon_to_update, order_to_update)
            
            # Execute query to update data
            execute_query(db_connection, query, data)

        # Redirect to same webpage after form submission
        return redirect(url_for('orders'))


@app.route('/coupons', methods=['GET', 'POST'])
def coupons():
    """Serves the Coupons Products page"""

    # Handle GET requests by fetching all Customers data
    if request.method == 'GET':
        query = "SELECT * FROM `Coupons`;"
        coupon_info = execute_query(db_connection, query).fetchall()
        return render_template("coupons.html", coupon_info=coupon_info)

    # Handle POST requests by inserting form data from front end
    if request.method == 'POST':
        couponID = request.form['couponID']
        percentDiscount = request.form['percentDiscount']
        expirationDate = request.form['expirationDate']
        
        query = "INSERT IGNORE INTO `Coupons` VALUES (%s, %s, %s);"
        data = (couponID, percentDiscount, expirationDate)
        
        # Execute query to insert data
        execute_query(db_connection, query, data)
        
        # Redirect to same webpage after form submission
        return redirect(url_for('coupons'))


@app.route('/orderProducts', methods=['GET', 'POST'])
def order_products():
    """Serves the Order Products page"""

    # Handle GET requests by fetching all Customers data
    if request.method == 'GET':
        query = "SELECT * FROM `OrderProducts`;"
        order_products_info = execute_query(db_connection, query).fetchall()
        
        # Fetch all orderID's for drop down menu
        query_orders = "SELECT `orderID` FROM `Orders` ORDER BY `orderID`;"
        orders_info = execute_query(db_connection, query_orders)
        
        # Fetch all productID's for drop down menu
        query_products = "SELECT `productID`, `albumName` FROM `Vinyls` ORDER BY `productID`;"
        products_info = execute_query(db_connection, query_products)
        return render_template("order-products.html", \
                                order_products_info=order_products_info, \
                                orders_info=orders_info, \
                                products_info=products_info)

    # Handle POST requests by inserting form data from front end
    if request.method == 'POST':
        orderID = request.form['orderID']
        productID = request.form['productID']
        quantity = request.form['quantity']
        
        query = "INSERT IGNORE INTO `OrderProducts` VALUES (%s, %s, %s);"
        data = (orderID, productID, quantity)
        
        # Execute query to insert data
        execute_query(db_connection, query, data)

        # Redirect to same webpage after form submission
        return redirect(url_for('order_products'))


@app.route('/orderProducts/delete', methods=['POST'])
def order_products_delete():
    """Handles DELETE requests for the OrderProducts table"""

    # Get form parameters
    order_prod_id = request.form['orderID_productID'].split(",")
    order_id = order_prod_id[0]
    product_id = order_prod_id[1]

    # Execute delete query using parameters
    query = "DELETE FROM `OrderProducts` WHERE `orderID` = %s AND `productID` = %s;"
    data = (order_id, product_id)
    execute_query(db_connection, query, data)    

    # Redirect to same webpage
    return redirect(url_for('order_products'))


# Listener
if __name__ == "__main__":
    port = int(os.environ.get('PORT', 8796)) 
    #                                 ^^^^
    #              You can replace this number with any valid port
    
    app.run(port=port, debug=True) 
