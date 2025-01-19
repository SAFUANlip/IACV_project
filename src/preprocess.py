import sqlite3
import numpy as np

# Path to the COLMAP database
db_path = '../datasets/south-building/database.db'

# Connect to the SQLite database
conn = sqlite3.connect(db_path)
cursor = conn.cursor()

# List all columns in the 'two_view_geometries' table
cursor.execute("PRAGMA table_info(two_view_geometries);")
columns = cursor.fetchall()

# Print the column names
for col in columns:
    print(col)

conn.close()

