#!/bin/bash
CERT_PATH=$1
MODE=$2  # Segundo parámetro para definir el tipo de salida

if [ ! -f "$CERT_PATH" ]; then
    if [ "$MODE" == "message" ]; then
        echo "🚨 [ERROR] Certificado no encontrado: $CERT_PATH"
    else
        echo "0"  # Devuelve 0 si el certificado no existe
    fi
    exit 1
fi

EXPIRATION_DATE=$(openssl x509 -enddate -noout -in "$CERT_PATH" | cut -d= -f2)
EXPIRATION_TIMESTAMP=$(date -d "$EXPIRATION_DATE" +%s)
CURRENT_TIMESTAMP=$(date +%s)

DAYS_LEFT=$(( (EXPIRATION_TIMESTAMP - CURRENT_TIMESTAMP) / 86400 ))

if [ "$MODE" == "message" ]; then
    if [ "$DAYS_LEFT" -le 5 ]; then
        ICON="🚨"
        ALERT="ALERTA CRÍTICA"
    elif [ "$DAYS_LEFT" -le 15 ]; then
        ICON="⚡"
        ALERT="PRECAUCIÓN"
    elif [ "$DAYS_LEFT" -le 30 ]; then
        ICON="📢"
        ALERT="AVISO IMPORTANTE"
    else
        ICON="✅"
        ALERT="Certificado OK"
    fi
    echo "$ICON [$ALERT] El certificado SSL para \"$CERT_PATH\" expirará en $DAYS_LEFT días."
else
    echo "$DAYS_LEFT"  # Devuelve solo el número de días si no es modo mensaje
fi

