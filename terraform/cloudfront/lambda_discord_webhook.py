import json
import os
import requests

def lambda_handler(event, context):
    discord_webhook_url = os.getenv('DISCORD_WEBHOOK_URL')
    sns_message = event['Records'][0]['Sns']['Message']
    message_dict = json.loads(sns_message)

    if 'AlarmName' in message_dict and 'NewStateValue' in message_dict:
        alarm_name = message_dict['AlarmName']
        alarm_state = message_dict['NewStateValue']

        if 'faturamento' in alarm_name.lower():
            message = f"O Alarme de Faturamento foi acionado. Novo Estado: {alarm_state}"
        elif 'acessos' in alarm_name.lower():
            message = f"O Alarme de Acessos de Usuários foi acionado. Novo Estado: {alarm_state}"
        elif 'disponibilidade' in alarm_name.lower():
            message = f"O Alarme de Disponibilidade do Site foi acionado. Novo Estado: {alarm_state}"
        else:
            message = f"O Alarme {alarm_name} foi acionado. Novo Estado: {alarm_state}"
    else:
        message = "Uma notificação desconhecida foi recebida."

    data = {
        "content": message
    }

    requests.post(discord_webhook_url, data=json.dumps(data), headers={"Content-Type": "application/json"})