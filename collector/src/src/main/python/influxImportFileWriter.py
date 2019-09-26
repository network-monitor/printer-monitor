from printerAndPrinterAccessories import *
import time

class InfluxImportFileWriter():
    def __init__(self, scanned, successfullyScanned, printers, elapsedTime):
        self.scanned = scanned
        self.successfullyScanned = successfullyScanned
        self.printers = printers
        self.elapsedTime = elapsedTime
        self.date = time.strftime("%m/%d/%Y %H:%M:%S")
        # self.headers = ["Host", "Name", "Uptime", "Life Count", "Power Cycle Count", "Supplies"]

    def generateInfluxFile(self):
        page = ""
        page += "# DML\n"
        page += "# CONTEXT-DATABASE: ebridge\n"
        for printer in self.printers:
            page += printer.toInfluxFileFormat()

        return page

    def __str__(self):
        return self.generateInfluxFile()
