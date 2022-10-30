import sqlite3
import main


class SQL:
    def __init__(self, path='signals.sqlite') -> None:
        self.db = sqlite3.connect(path)
        self.cursor = self.db.cursor()
        try:
            with self.db:
                self.db.execute(f'''CREATE TABLE IF NOT EXISTS signals(
                    account VARCHAR(25) NOT NULL,
                    balance REAL NOT NULL,
                    symbol VARCHAR(15) NOT NULL,
                    volume REAL NOT NULL,
                    ticket LONG NOT NULL,
                    type LONG NOT NULL,
                    time DATETIME NOT NULL,
                    open REAL NOT NULL,
                    sl REAL NOT NULL,
                    tp REAL NOT NULL,
                    res VARCHAR(15))
                    ''')
        except self.db.Error as ex:
            print(ex)
        self.db.commit()
    
    def __enter__(self):
        return self

    def add_signal(self, s:main.Signal):
        with self.db:
            return self.cursor.execute(f'INSERT INTO signals VALUES(?,?,?,?,?,?,?,?,?,?,?)', (s.account, s.balance, s.symbol, s.volume, s.ticket, s.type_, s.time, s.open_, s.sl, s.tp, s.order))
    
    def check_signal(self, s:main.Signal):
        with self.db:
            return self.cursor.execute(f'SELECT *  FROM signals WHERE ticket=?', (s.ticket,)).fetchone()
    
    #def modify_signal(self, s:Signal):
     #   with self.db:
      #      return self.cursor.execute(f'UPDATE signals SET sl=?, tp=?, ',


    def __exit__(self, *args, **kwargs):
        self.db.commit()
        self.db.close()
