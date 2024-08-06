
class CustomError(Exception):

    # Constructor or Initializer
    def __init__(self, message):
        self.message = message

    # __str__ is to print() the value
    def __str__(self):
        return repr(self.message)
