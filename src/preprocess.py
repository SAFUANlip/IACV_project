import sqlite3
import shutil


def create_new_db_with_removed_ids_via_query(original_db_path, ids_to_remove_txt_path, new_db_path):
    """
    Creates a new COLMAP database by removing rows using a SELECT query.

    Args:
        original_db_path (str): Path to the original COLMAP database file (.db).
        ids_to_remove_txt_path (str): Path to the .txt file containing `pair_id`s to remove.
        new_db_path (str): Path to the new database file to be created.
    """
    # Copy the original database to a new file
    shutil.copyfile(original_db_path, new_db_path)

    # Read pair_ids to be removed from the text file
    with open(ids_to_remove_txt_path, "r") as f:
        ids_to_remove = [line.strip() for line in f]

    # Format the IDs into a comma-separated string for the SQL query
    ids_to_remove_str = ', '.join(ids_to_remove)

    # Connect to the new database
    conn = sqlite3.connect(new_db_path)
    cursor = conn.cursor()

    # Use the DELETE query to remove rows matching the IDs
    cursor.execute(f"""
        DELETE FROM two_view_geometries
        WHERE pair_id IN ({ids_to_remove_str})
    """)

    # Commit changes and close the connection
    conn.commit()
    conn.close()


def extract_matches_to_txt(db_path, output_txt_path):
    """
    Extracts `pair_id` and `num_of_matches` using the `rows` column from a COLMAP database file
    and writes them to a .txt file.

    Args:
        db_path (str): Path to the COLMAP database file (.db).
        output_txt_path (str): Path to the output .txt file.
    """
    # Connect to the COLMAP database
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Query to get pair_id and num_of_matches from the rows column
    cursor.execute("""
        SELECT pair_id, rows AS num_of_matches
        FROM matches
    """)

    # Fetch all results
    results = cursor.fetchall()

    # Write results to a text file
    with open(output_txt_path, "w") as f:
        for pair_id, num_of_matches in results:
            f.write(f"{pair_id} {num_of_matches}\n")

    # Close the connection
    conn.close()


# Example usage
# db_file = "../datasets/Alcatraz/alcatraz_database.db"
# output_file = "../datasets/Alcatraz/alcatraz_matches.txt"
# extract_matches_to_txt(db_file, output_file)

original_db = "../datasets/Alcatraz/alcatraz_database.db"
ids_to_remove_txt = "../datasets/Alcatraz/filtered_alcatraz_matches.txt"
new_db = "../datasets/Alcatraz/filtered_alcatraz_database.db"
create_new_db_with_removed_ids_via_query(original_db, ids_to_remove_txt, new_db)

