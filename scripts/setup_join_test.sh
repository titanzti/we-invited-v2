#!/bin/bash

# Quick setup script for cross-user join testing
# This creates test users and an event via API calls

API_BASE="http://localhost:3000"

echo "🚀 Setting up cross-user join test..."
echo ""

# Check if API is running
echo "📡 Checking API connection..."
if ! curl -s "$API_BASE/health" > /dev/null 2>&1; then
  echo "❌ API is not running at $API_BASE"
  echo "Please start your backend server first!"
  exit 1
fi
echo "✅ API is running"
echo ""

# Register User A
echo "📝 Registering User A (Event Creator)..."
TIMESTAMP=$(date +%s)
USER_A_EMAIL="testuser_a_${TIMESTAMP}@example.com"
USER_A_NAME="Test User A"
USER_A_PASSWORD="password123"

RESPONSE_A=$(curl -s -X POST "$API_BASE/auth/register" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"$USER_A_NAME\",
    \"email\": \"$USER_A_EMAIL\",
    \"password\": \"$USER_A_PASSWORD\"
  }")

TOKEN_A=$(echo "$RESPONSE_A" | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN_A" ]; then
  echo "❌ Failed to register User A"
  echo "Response: $RESPONSE_A"
  exit 1
fi

echo "✅ User A registered: $USER_A_EMAIL"
echo ""

# Create Event as User A
echo "🎉 Creating event as User A..."
EVENT_TITLE="Test Event by User A - $TIMESTAMP"

RESPONSE_EVENT=$(curl -s -X POST "$API_BASE/events" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN_A" \
  -d "{
    \"title\": \"$EVENT_TITLE\",
    \"location\": \"Bangkok, Thailand\",
    \"category\": \"Social\",
    \"description\": \"This is a test event created by User A for join testing\",
    \"startdateTime\": \"$(date -v+7d +%Y-%m-%dT18:00:00.000Z)\",
    \"entdateTime\": \"$(date -v+7d +%Y-%m-%dT22:00:00.000Z)\",
    \"requiresApproval\": false,
    \"latitude\": 13.7563,
    \"longitude\": 100.5018
  }")

EVENT_ID=$(echo "$RESPONSE_EVENT" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4)

if [ -z "$EVENT_ID" ]; then
  echo "❌ Failed to create event"
  echo "Response: $RESPONSE_EVENT"
  exit 1
fi

echo "✅ Event created: $EVENT_TITLE"
echo "   Event ID: $EVENT_ID"
echo ""

# Register User B
echo "📝 Registering User B (Event Joiner)..."
USER_B_EMAIL="testuser_b_${TIMESTAMP}@example.com"
USER_B_NAME="Test User B"
USER_B_PASSWORD="password123"

RESPONSE_B=$(curl -s -X POST "$API_BASE/auth/register" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"$USER_B_NAME\",
    \"email\": \"$USER_B_EMAIL\",
    \"password\": \"$USER_B_PASSWORD\"
  }")

TOKEN_B=$(echo "$RESPONSE_B" | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN_B" ]; then
  echo "❌ Failed to register User B"
  echo "Response: $RESPONSE_B"
  exit 1
fi

echo "✅ User B registered: $USER_B_EMAIL"
echo ""

# Test Join Event as User B
echo "🤝 Testing join event as User B..."
RESPONSE_JOIN=$(curl -s -X POST "$API_BASE/events/$EVENT_ID/join" \
  -H "Authorization: Bearer $TOKEN_B")

echo "Join Response: $RESPONSE_JOIN"
echo ""

# Summary
echo "🎉 Test setup complete!"
echo ""
echo "📊 Test Credentials:"
echo "   User A (Creator):"
echo "     Email: $USER_A_EMAIL"
echo "     Password: $USER_A_PASSWORD"
echo ""
echo "   User B (Joiner):"
echo "     Email: $USER_B_EMAIL"
echo "     Password: $USER_B_PASSWORD"
echo ""
echo "   Event Details:"
echo "     Title: $EVENT_TITLE"
echo "     ID: $EVENT_ID"
echo ""
echo "📱 You can now:"
echo "   1. Login as User A to see the created event"
echo "   2. Login as User B and join the event"
echo "   3. Run the integration test: flutter test integration_test/cross_user_join_test.dart"
echo ""
