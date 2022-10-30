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
        result = [format_signal_with_str((row[0]+'\t').split('\t')) for row in reader]
    return result


def check_signal():
    pass 


def push_orders():
    pass


def format_signal_with_str(s:tuple) -> Signal:
    return Signal(s[0], float(s[1]), s[2], float(s[3]), int(s[4]), int(s[5]), int(s[6]), float(s[7]), float(s[8]), float(s[9]), s[10])


def main():
    try:
        DB = database.SQL()
        get_p = Path(get_path)
        get_file_path = Path.joinpath(get_p, NAME_FILE)
        # TODO while True: enable cicle!!!!!
        if Path.is_file(get_file_path):
            list_signals = get_file(path_file=get_file_path)
            must_open = []
            must_modify = []
            dont_turn = []
            db_signals=DB.all_orders_not_close()
            temp_list_signals = [tuple(par for par in signal) for signal in db_signals]
            for signal in list_signals:
                if db_signal:=DB.check_signal(signal):
                    if tuple(str(par) for par in db_signal) == tuple(str(param) for param in signal):
                        dont_turn.append(signal)
                    else:
                        DB.modify_signal(signal)
                        must_modify.append(signal)
                else:
                    DB.add_signal(signal)
                    must_open.append(signal)

            for signal in [*must_open, *must_modify, *dont_turn]:
                if tuple(signal) in temp_list_signals:
                    temp_list_signals.remove(signal)
            must_close =  [format_signal_with_str(s) for s in temp_list_signals]

            # TODO Write file
    except KeyboardInterrupt:
        print('Quite')

if __name__ == '__main__':
    main()
