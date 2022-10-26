from pathlib import Path
from config import get_path, put_path

NAME_FILE = 'signal.csv'


def clone_csv():
    get_p = Path(get_path)
    put_p = Path(put_path)

    get_file_path = Path.joinpath(get_p, NAME_FILE)
    put_file_path = Path.joinpath(put_p, NAME_FILE)
    if Path.is_file(get_file_path):
        put_file_path.write_bytes(get_file_path.read_bytes())
        get_file_path.unlink()
        print(get_file_path)
    else:
        print('nofile')
            



def main():
    try:
        while True:
            clone_csv()
    except KeyboardInterrupt:
        print('Quite')

if __name__ == '__main__':
    main()
