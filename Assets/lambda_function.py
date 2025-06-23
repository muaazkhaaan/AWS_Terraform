import json


def lambda_handler(event, context):
    # Get the length and width parameters from the event object. The 
    # runtime converts the event object to a Python dictionary
    length = event['length']
    width = event['width']

    area = calculate_area(length, width)
    print(f"The area is {area}")

    # return the calculated area as a JSON string
    data = {"area": area}
    return json.dumps(data)


def calculate_area(length, width):
    return length*width
