# MCQ Corrector - API Integration Guide

This document explains how to integrate the Flutter app with your backend APIs.

## Overview

The Flutter app is designed to send MCQ images to your backend for processing and receive structured results. The app handles camera functionality, UI, and API communication.

## Required API Endpoints

### 1. Process MCQ Image
**Endpoint:** `POST /api/process-mcq`
**Content-Type:** `multipart/form-data`

**Request:**
```
image: File (JPG/PNG)
```

**Response:**
```json
{
  "id": "unique_result_id",
  "imageUrl": "processed_image_url",
  "totalQuestions": 10,
  "correctAnswers": 7,
  "wrongAnswers": 3,
  "accuracy": 0.7,
  "questions": [
    {
      "questionNumber": 1,
      "userAnswer": "A",
      "correctAnswer": "A",
      "isCorrect": true,
      "questionText": "Optional question text"
    }
  ],
  "createdAt": "2024-01-01T12:00:00Z"
}
```

### 2. Get User Results (Optional)
**Endpoint:** `GET /api/results?userId={userId}`

**Response:**
```json
[
  {
    "id": "result_id",
    "imageUrl": "image_url",
    "totalQuestions": 10,
    "correctAnswers": 7,
    "wrongAnswers": 3,
    "accuracy": 0.7,
    "createdAt": "2024-01-01T12:00:00Z"
  }
]
```

### 3. Save Feedback (Optional)
**Endpoint:** `POST /api/feedback`
**Content-Type:** `application/json`

**Request:**
```json
{
  "resultId": "result_id",
  "rating": 5,
  "comment": "Great accuracy!"
}
```

## Configuration

### Update API Base URL
In `lib/services/api_service.dart`, update the base URL:

```dart
static const String baseUrl = 'https://your-actual-backend-url.com/api';
```

### Authentication (if needed)
If your API requires authentication, update the headers in `api_service.dart`:

```dart
static Map<String, String> get headers => {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer your_token_here',
};
```

## Image Processing Requirements

Your backend should:

1. **Accept image uploads** in JPG/PNG format
2. **Process MCQ sheets** using OCR/ML techniques
3. **Extract answers** from filled circles/marks
4. **Compare with answer key** (you'll need to define how answer keys are provided)
5. **Return structured results** as shown in the JSON format above

## Error Handling

The app handles these scenarios:
- Network errors
- Invalid image formats
- API response errors
- Processing timeouts

Ensure your API returns appropriate HTTP status codes:
- `200` - Success
- `400` - Bad request (invalid image, etc.)
- `500` - Server error

## Testing

For testing without a backend:
1. The app currently uses mock data
2. Comment out the mock result section in `main.dart`
3. Uncomment the actual API call:

```dart
// Replace the mock result with:
final result = await ApiService.uploadMCQImage(imageFile);
if (result != null) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ResultsScreen(result: result),
    ),
  );
}
```

## Performance Considerations

- Compress images before sending (app does this automatically)
- Implement proper caching for results
- Consider implementing offline storage for when network is unavailable
- Add retry logic for failed requests

## Security

- Implement proper authentication
- Validate image sizes and formats
- Use HTTPS for all API calls
- Consider rate limiting on your backend

## Next Steps

1. Set up your backend with the required endpoints
2. Update the `baseUrl` in `api_service.dart`
3. Test the integration
4. Implement any additional features needed

## Flutter Dependencies

The app uses these packages for API integration:
- `http: ^1.1.0` - HTTP requests
- `image_picker: ^1.0.4` - Camera functionality
- `camera: ^0.10.5+2` - Advanced camera features

Run `flutter pub get` to install dependencies.

## Contact

If you need any modifications to the data structure or additional endpoints, please let the Flutter developer know. 