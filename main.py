from pathlib import Path
from config import get_path, put_path
import csv
from typing import NamedTuple
from datetime import datetime 
import database 

class Signal(NamedTuple):
    account:str
    balance:float
    symbol:str
    volume:float
    ticket:int
    type_:int
    time:datetime
    open_:float
    sl:float
    tp:float
    res:str

NAME_FILE = 'signal.csv'


def get_file(path_file:Path) -> list:
    result = []
    with path_file.open(newline='', encoding='cp1252') as file:
        reader = csv.reader(file)
        result = [Signal(*(row[0]+'\t').split('\t')) for row in reader]
    return result


def check_signal():
    pass 


def push_orders():
    pass


def main():
    try:
        DB = database.SQL()
        get_p = Path(get_path)
        get_file_path = Path.joinpath(get_p, NAME_FILE)
        # TODO while True: enable cicle!!!!!
        if Path.is_file(get_file_path):
            list_signals = get_file(path_file=get_file_path)
            for signal in list_signals:
                if db_signal:=DB.check_signal(signal):
                    if tuple(str(par) for par in db_signal) == tuple(param for param in signal):
                        print(db_signal)
                    else:
                        print(DB.modify_signal(signal))
                else:
                    DB.add_signal(signal)
            # TODO check orders must close...
            # TODO Write file
    except KeyboardInterrupt:
        print('Quite')

if __name__ == '__main__':
    main()
