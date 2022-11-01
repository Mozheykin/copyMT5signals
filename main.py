from pathlib import Path
from pprint import pprint
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
        while True: 
            if Path.is_file(get_file_path):
                list_signals = get_signals(path_file=get_file_path)
                must_open = []
                must_modify = []
                dont_turn = []
                db_signals=DB.all_orders_not_close()
                temp_list_signals = [tuple(par for par in signal) for signal in db_signals]
                for signal in list_signals:
                    db_signal = DB.check_signal(signal)
                    if db_signal:
                        if tuple(str(par) for par in db_signal) == tuple(str(param) for param in signal):
                            dont_turn.append(signal)
                            continue
                        else:
                            DB.modify_signal(signal)
                            new_signal = Signal(*signal[:-1], 'MODIFY')
                            must_modify.append(new_signal)
                            continue
                    else:
                        DB.add_signal(signal)
                        new_signal = Signal(*signal[:-1], 'OPEN')
                        must_open.append(new_signal)
                        continue

                #pprint(f"Don't change orders: {*must_modify, *must_open, *dont_turn}")
                for signal in [*must_open, *must_modify, *dont_turn]:
                    for id_, temp_signal in enumerate(temp_list_signals):
                        if signal.ticket == temp_signal[4]:
                            temp_list_signals.pop(id_)
                must_close =  [format_signal_with_str(s, 'CLOSE') for s in temp_list_signals]
                #pprint(f"Close orders: {must_close}")
                if must_close:
                    for signal in must_close:
                        DB.change_close_orders(signal)

                while True: 
                    if not Path.is_file(put_file_path):
                        set_signals(put_file_path, [*must_open, *must_modify, *must_close])
                        break
    except KeyboardInterrupt:
        print('Quite')

if __name__ == '__main__':
    main()
