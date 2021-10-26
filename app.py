from flask import Flask, render_template, json
import os
import database.db_connector as db


# Configuration

app = Flask(__name__)

#db_connection = db.connect_to_database()


# Routes 

@app.route('/')
def root():
    """Serves the website home page"""
    return render_template("index.html")

@app.route('/customers')
def customers():
    """Serves the Customers page"""
    return render_template("customers.html")

@app.route('/orders')
def orders():
    """Serves the Orders page"""
    return render_template("orders.html")

@app.route('/vinyls')
def vinyls():
    """Serves the Vinyls page"""
    return render_template("vinyls.html")

@app.route('/orderProducts')
def order_products():
    """Serves the Order Products page"""
    return render_template("order-products.html")

@app.route('/coupons')
def coupons():
    """Serves the Coupons Products page"""
    return render_template("coupons.html")


# Listener

if __name__ == "__main__":
    port = int(os.environ.get('PORT', 9112)) 
    #                                 ^^^^
    #              You can replace this number with any valid port
    
    app.run(port=port, debug=True) 
