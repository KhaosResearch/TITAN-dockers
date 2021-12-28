import os
from email import encoders
from email.mime.base import MIMEBase
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from os.path import basename
from smtplib import SMTP

import typer


def _create_smtp():
    return SMTP(host="correo.uma.es", port=587)


def send_by_email(
    filepath: str = typer.Option(..., help="Name of the xlsx file"),
    user: str = typer.Option(..., help="User of the email"),
    password: str = typer.Option(..., help="Password of the email"),
    to_email: str = typer.Option(..., help="Name of the receptor of the email"),
    subject: str = typer.Option(..., help="Subject of the email"),
    body: str = typer.Option(..., help="Body of the email"),
):
    os.chdir("data")
    with _create_smtp() as smtp:
        # smtp.set_debuglevel(1)
        smtp.starttls()
        smtp.login(user, password)
        msg = MIMEMultipart()
        msg["From"] = user
        msg["To"] = to_email
        msg["subject"] = subject
        message = body

        # Attach body
        msg.attach(MIMEText(message, "plain"))

        # open the file in binary
        payload = MIMEBase("application", "octate-stream", Name=basename(filepath))

        with open(filepath, "rb") as binary_file:
            payload.set_payload((binary_file).read())

        # enconding the binary into base64
        encoders.encode_base64(payload)

        # add header with the file name
        payload.add_header("Content-Decomposition", "attachment", filename=basename(filepath))
        msg.attach(payload)

        # Send email
        smtp.sendmail(msg["FROM"], msg["TO"], msg.as_string())


if __name__ == "__main__":
    typer.run(send_by_email)
