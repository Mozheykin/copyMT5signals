from pathlib import Path
from config import get_path, put_path
from typing import NamedTuple
from datetime import datetime 
import database 
from signals_mt import format_signal_with_str, get_signals, set_signals

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


def main():
    try:
        DB = database.SQL()
        get_p = Path(get_path)
        get_file_path = Path.joinpath(get_p, NAME_FILE)
        put_p = Path(put_path)
        put_file_path = Path.joinpath(put_p, NAME_FILE)
        # TODO while True: enable cicle!!!!!
        if Path.is_file(get_file_path):
            list_signals = get_signals(path_file=get_file_path)
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
                        signal.res = 'MODIFY'
                        must_modify.append(signal)
                else:
                    DB.add_signal(signal)
                    signal.res = 'OPEN'
                    must_open.append(signal)

            for signal in [*must_open, *must_modify, *dont_turn]:
                if tuple(signal) in temp_list_signals:
                    temp_list_signals.remove(signal)
            must_close =  [format_signal_with_str(s, 'CLOSE') for s in temp_list_signals]
            if must_close:
                for signal in must_close:
                    DB.change_close_orders(signal)

            if not Path.is_file(put_file_path):
                set_signals(put_file_path, [*must_open, *must_modify, *must_close])
    except KeyboardInterrupt:
        print('Quite')

if __name__ == '__main__':
    main()
