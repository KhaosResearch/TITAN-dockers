import os
from ftplib import FTP
from os.path import basename

import typer


def _create_ftp_connection(server, port):
    ftp = FTP()
    ftp.connect(host = server, port = port)
    return ftp


def copy_file_ftp(
    filepath: str = typer.Option(..., help="Name of the file to store"),
    server: str = typer.Option(..., help = "Server address of FTP"),
    port: int = typer.Option(..., help = "Port of FTP server"),
    user: str = typer.Option(..., help = "User of FTP server"),
    password: str = typer.Option(..., help = "Password of FTP user"),
    path: str = typer.Option(..., help = "Path to copy the file")
):

    os.chdir("data")
    with _create_ftp_connection(server, port) as ftp:
        ftp.login(user, password)
        ftp.cwd(path)

        with open(filepath, "rb") as _file:
            ftp.storbinary(f"STOR {basename(filepath)}", _file)


if __name__ == "__main__":
    typer.run(copy_file_ftp)
