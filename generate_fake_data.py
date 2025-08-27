import csv
import random
import time


def generate_sensor_data_csv(num_customers=50, num_sites=3, num_sensors=100):
    """
    Generates a CSV file with sensor data for a specified number of
    customers, sites, and sensors, formatted as requested.

    Args:
        num_customers (int): The number of customers to simulate.
        num_sites (int): The number of sites per customer.
        num_sensors (int): The number of sensors per site.
    """
    # Define the output file name
    output_filename = "data.csv"

    # Define the header row
    header = ["", "temperature", "humidity"]

    with open(output_filename, "w", newline="") as csvfile:
        csv_writer = csv.writer(csvfile)

        # Write the header
        csv_writer.writerow(header)

        # Set a base timestamp (e.g., now) for the data
        base_timestamp = int(time.time())

        # Loop to generate data for customers
        for cust_num in range(1, num_customers + 1):
            customer_id = f"customer{cust_num}"

            # Loop for each site
            for site_num in range(1, num_sites + 1):
                site_id = f"site{site_num}"

                # Loop for each sensor, generating multiple readings
                for sensor_num in range(1, num_sensors + 1):
                    sensor_id = f"sensor{sensor_num}"

                    # Generate a few readings for each sensor to simulate time progression
                    for reading_count in range(120):
                        # Create the formatted row key
                        row_key = f"{customer_id}#{site_id}#{sensor_id}#{base_timestamp + reading_count * 60}"

                        # Generate random values for temperature and humidity
                        temperature = random.randint(90, 110)
                        humidity = random.randint(40, 60)

                        # Write the row to the CSV file
                        csv_writer.writerow([row_key, temperature, humidity])

    print(f"Successfully generated {output_filename}")


if __name__ == "__main__":
    generate_sensor_data_csv()
