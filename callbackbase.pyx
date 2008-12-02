import purple
import ecore

class CallBackBase:
    def __init__(self, dict_cbs):
        self.cbs = dict_cbs
    
    def add_callback(self, name, func):
        self.cbs[name] = func

    def call_callback(self, name):
        self.cbs[name] = (data, user)
