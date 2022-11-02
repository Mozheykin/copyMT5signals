import csv
from pathlib import Path
import main


def format_signal_with_str(s:tuple, res:str=''):
    return main.Signal(s[0], float(s[1]), s[2], float(s[3]), int(s[4]), int(s[5]), int(s[6]), float(s[7]), float(s[8]), float(s[9]), res)


def get_signals(path_file:Path) -> list:
    result = []
    with path_file.open(newline='', encoding='cp1252') as file:
        reader = csv.reader(file)
        result = [format_signal_with_str((row[0]+'\t').split('\t')) for row in reader]
    return result

def set_signals(path_file:Path, signals:list) -> bool:
    print(signals)
    with path_file.open('w', newline='') as file:
        csv_writer = csv.writer(file, delimiter=';', quotechar='|', quoting=csv.QUOTE_MINIMAL)
        for signal in signals:
            csv_writer.writerow([s for s in signal])
    return True