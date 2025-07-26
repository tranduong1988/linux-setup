if ls /usr/share/themes ~/.themes | grep -iq matcha; then
  echo "✅ Matcha theme is installed"
else
  echo "❌ Matcha theme not found"
fi

if ls /usr/share/icons ~/.icons | grep -iq papirus; then
  echo "✅ Papirus icon theme is installed"
else
  echo "❌ Papirus icon theme not found"
fi
