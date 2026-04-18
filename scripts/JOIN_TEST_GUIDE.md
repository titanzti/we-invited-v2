# Cross-User Join Test Guide

This guide helps you test the event join functionality with two different user accounts.

## Quick Start

### Option 1: Automated Setup Script (Recommended)

Run the setup script to automatically create test users and an event:

```bash
./scripts/setup_join_test.sh
```

This script will:
1. ✅ Register User A (Event Creator)
2. ✅ Create a test event as User A
3. ✅ Register User B (Event Joiner)
4. ✅ Test joining the event via API
5. ✅ Display credentials for manual testing

### Option 2: Integration Test

Run the full integration test that automates the entire flow:

```bash
fvm flutter test integration_test/cross_user_join_test.dart
```

This test will:
1. Register User A via the app UI
2. Create an event as User A
3. Logout User A
4. Register User B
5. Find and join User A's event as User B
6. Verify the join was successful

### Option 3: Manual Testing

#### Step 1: Create User A and Event

1. Open the app and register a new account:
   - Name: `Test User A`
   - Email: `testuser_a@example.com`
   - Password: `password123`

2. Create an event:
   - Tap the `+` FAB button
   - Fill in event details:
     - Title: `Test Event for Join`
     - Location: `Bangkok, Thailand`
     - Category: `Social`
     - Description: `Test event for join functionality`
   - Tap `Create Event`

3. Note the event appears in your feed

4. Logout from Profile screen

#### Step 2: Join as User B

1. Register a new account:
   - Name: `Test User B`
   - Email: `testuser_b@example.com`
   - Password: `password123`

2. Find the event:
   - The event should appear in the Discover feed
   - Or use the search function to find "Test Event for Join"

3. Join the event:
   - Tap on the event card
   - Tap the `Join Event` button
   - Verify success message appears

## Test Scenarios

### Scenario 1: Public Event (No Approval Required)
- User creates event with `requiresApproval: false`
- Another user joins → Immediate success message "You're in!"

### Scenario 2: Approval Required Event
- User creates event with `requiresApproval: true`
- Another user joins → Message "Request sent"
- Event owner can approve/reject in "My Events" → "Join Requests"

### Scenario 3: Already Joined
- User tries to join an event they already joined
- Should show appropriate message (handled in `post_repository.dart`)

### Scenario 4: Join Own Event
- User tries to join their own event
- Backend should prevent this (if implemented)

## API Endpoints Used

```bash
# Register User
POST /auth/register
{
  "name": "string",
  "email": "string",
  "password": "string"
}

# Create Event
POST /events
Authorization: Bearer <token>
{
  "title": "string",
  "location": "string",
  "category": "string",
  "description": "string",
  "startdateTime": "ISO8601",
  "entdateTime": "ISO8601",
  "requiresApproval": false,
  "latitude": 13.7563,
  "longitude": 100.5018
}

# Join Event
POST /events/:eventId/join
Authorization: Bearer <token>

# Get Event Details
GET /events/:eventId
Authorization: Bearer <token>

# Get Join Requests (for event owner)
GET /events/:eventId/requests
Authorization: Bearer <token>
```

## Troubleshooting

### API Not Running
```bash
# Start your backend server (we-invited-api)
cd ../we-invited-api
bun run dev
```

### Event Not Appearing in Feed
- Check if the event date is in the future
- Verify the event category matches your filter
- Try scrolling down or using search

### Join Button Not Visible
- Event might be in the past
- User might already be joined
- Event might be private or deleted

### Test Fails
Check the console output for detailed error messages:
- Registration errors
- Event creation errors
- Join request errors

## Files Created

1. `integration_test/cross_user_join_test.dart` - Full integration test
2. `scripts/setup_join_test.sh` - Quick API setup script
3. `scripts/JOIN_TEST_GUIDE.md` - This guide

## Next Steps

After testing the basic join functionality, you can:

1. **Test Approval Flow**:
   - Create event with approval required
   - Join as another user
   - Login as owner and approve/reject

2. **Test Edge Cases**:
   - Join event that's already full
   - Join event that's in the past
   - Cancel RSVP (if implemented)

3. **Test UI States**:
   - Loading state while joining
   - Error state on network failure
   - Success toast/notification

## Support

If you encounter issues:
1. Check backend logs for API errors
2. Verify JWT tokens are being stored correctly
3. Ensure database is running and accessible
4. Check Flutter DevTools for widget tree issues
