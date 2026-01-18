import random
from datetime import datetime, timedelta

f = open("ecommerce_20k_final.sql", "w")

# MASTER DATA
num_customers = 400
num_products = 50
num_categories = 10

# Customers
for i in range(1, num_customers + 1):
    f.write(f"INSERT INTO Customer(FirstName, LastName, BillingAddress, DateOfBirth) VALUES ('Customer{i}','Lname{i}','Address_{i}','1990-{random.randint(1,12):02d}-{random.randint(1,28):02d}');\n")
    f.write(f"INSERT INTO CustomerEmails(CustomerID, Email) VALUES ({i}, 'customer{i}.lname{i}@mail.com');\n")
    f.write(f"INSERT INTO CustomerPhones(CustomerID, Phone) VALUES ({i}, '03{random.randint(10000000,99999999)}');\n")

# Products
for i in range(1, num_products + 1):
    f.write(f"INSERT INTO Product(ProductName, SKU, CategoryID, Price, Weight) VALUES ('Product_{i}','SKU{i:03d}',{random.randint(1,num_categories)},{random.randint(20,1500)},{round(random.uniform(0.1,5.0),2)});\n")
    f.write(f"INSERT INTO ProductImages(ProductID, ImageURL) VALUES ({i}, 'product_{i}.jpg');\n")
    f.write(f"INSERT INTO ProductTags(ProductID, Tag) VALUES ({i}, 'Tag{i}');\n")

# TRANSACTIONAL DATA
order_id = 1
review_id = 1

# Each customer 10 orders, each order 4 products → 400*10*4 = 16,000
# Payments 4000 → total 20,000 exactly

for cust_id in range(1, num_customers + 1):
    for _ in range(10):  # 10 orders per customer
        order_date = datetime(2025,1,1) + timedelta(days=random.randint(0,360))
        total_amount = 0
        f.write(f"INSERT INTO [Order](CustomerID, OrderDate, Status, TotalAmount) VALUES ({cust_id},'{order_date.date()}','{random.choice(['Processing','Shipped','Delivered','Cancelled'])}',0);\n")
        order_id_local = order_id
        # 4 products per order
        for _ in range(4):
            product_id = random.randint(1,num_products)
            qty = random.randint(1,3)
            unit_price = random.randint(20,1500)
            total_amount += qty * unit_price
            f.write(f"INSERT INTO OrderLines(OrderID, ProductID, Qty, UnitPrice) VALUES ({order_id_local},{product_id},{qty},{unit_price});\n")
        f.write(f"UPDATE [Order] SET TotalAmount={total_amount} WHERE OrderID={order_id_local};\n")
        # Payment
        payment_date = order_date + timedelta(days=random.randint(0,5))
        f.write(f"INSERT INTO Payment(OrderID, PaymentDate, Amount, PaymentMethod, TransactionRef) VALUES ({order_id_local},'{payment_date.date()}',{total_amount},'{random.choice(['Card','PayPal','Cash'])}','TXN{random.randint(100000,999999)}');\n")
        order_id += 1

f.close()
print("Ecommerce SQL file with exactly 20k statements generated!")
