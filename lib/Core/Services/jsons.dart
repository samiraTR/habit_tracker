class Demojson {
  final routineJson = '''{
  "routines": [
    {
      "id": 1,
      "name": "Morning Routine",
      "tasks": [
        {"id": 1, "name": "Wake up", "completed": false},
        {"id": 2, "name": "Brush teeth", "completed": false},
        {"id": 3, "name": "Exercise", "completed": false}
      ]
    },
    {
      "id": 2,
      "name": "Evening Routine",
      "tasks": [
        {"id": 1, "name": "Dinner", "completed": false},
        {"id": 2, "name": "Read a book", "completed": false},
        {"id": 3, "name": "Sleep", "completed": false}
      ]
    }
  ]
}''';

  final scheduleJson = '''{
    "tasks":[
    {
    "id":1,
    "time":"9:00 AM",
        "date":"2025-06-02",
        "task":"Meeting with team",
        "alarm":true, 
    },
    {
    "id":2,
    "time":"10:00 AM",
        "date":"2025-06-02",
        "task":"Brekkie With Sabrin",
        "alarm":true, 
    },
  ]
 }''';
}

const journalJson = '''{
  "entries": [
    {
      "id": 1,
      "date": "2025-06-01",
      "content": "Had a great day! Completed all my tasks and felt productive."
    },
    {
      "id": 2,
      "date": "2025-06-02",
      "content": "Struggled to stay focused today. Need to work on time management."
    }
  ]
}''';

const goalJson = '''{
  "goals": [
    {
      "id": 1,
      "title": "Lose Weight",
      "description": "Aim to lose 10 pounds in 3 months",
      "targetDate": "2025-09-01",
      "milestones": [
        {"id": 1, "title": "Lose 3 pounds", "completed": false},
        {"id": 2, "title": "Lose 6 pounds", "completed": false},
        {"id": 3, "title": "Lose 10 pounds", "completed": false}
      ],
      "progress": 30
    },
    {
      "id": 2,
      "title": "Read More Books",
      "description": "Read at least 20 books this year",
      "targetDate": "2025-12-31",
      "milestones": [
        {"id": 1, "title": "Read 2 books", "completed": false},
        {"id": 2, "title": "Read 5 books", "completed": false},
        {"id": 3, "title": "Read 8 books", "completed": false}
      ],
      "progress": 50
    }
  ]
}''';



