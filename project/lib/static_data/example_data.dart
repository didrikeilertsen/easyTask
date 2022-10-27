import '../models/comment.dart';
import '../models/project.dart';
import '../models/tag.dart';
import '../models/task.dart';

/// Temp list for testing.
class ExampleData {
  static List<Project> projects = [
    Project(
        title: "Household",
        tags: tags,
        tasks: [
          Task(
              title: "Vacuum the house",
              description: "Vacuum the living room, hallway and kitchen.",
              deadline: "23.10.2022",
              comments: [
                Comment(
                    author: "Erik",
                    date: "18.10.2022",
                    text: "Only had time to vacuum the living room and hallway."),
                Comment(
                    author: "Jens",
                    date: "19.10.2022",
                    text: "That's okay, your mother and I still love you. \nYou can do the rest tomorrow."),
              ],
              tags: [
                const Tag(
                  text: "urgent",
                  color: 0xFFFF0000,
                ),
              ]),
          Task(
              title: "Water flowers",
              deadline: "15.10.2022",
              description: "Water the flowers in the livingroom",
              tags: <Tag>[
                const Tag(
                  text: "green",
                  color: 0xFF8BC34A,
                ),
                const Tag(
                  text: "fun",
                  color: 0xFF0400FF,
                ),
              ]
          ),
        ]
    ),
    Project(
        title: "Garden",
        tags: tags,
        tasks: [
          Task(
              title: "Mow the lawn",
              description: "Mow the lawn on both sides of the house. Don't forget to rinse the lawn mower afterwards.",
              deadline: "26.10.2022",
              comments: [
                Comment(
                    author: "Jens",
                    date: "125.10.2022",
                    text: "Accidentally ran over the cat with the mower. \nCreated new issue: Take cat to the vet."
                ),
              ],
              tags: [
                const Tag(
                  text: "green",
                  color: 0xFF8BC34A,
                ),
              ]),
        ]
    )
  ];
  static List<Tag> tags = [
    const Tag(
      text: "urgent",
      color: 0xFFFF0000,
    ),
    const Tag(
      text: "green",
      color: 0xFF8BC34A,
    ),
    const Tag(
      text: "fun",
      color: 0xFF0400FF,
    ),
  ];
}