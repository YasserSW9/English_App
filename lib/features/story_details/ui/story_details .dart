import 'package:english_app/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:english_app/features/story_details/logic/cubit/story_cubit.dart';
import 'package:english_app/features/story_details/logic/cubit/story_state.dart';
import 'package:english_app/features/story_details/data/models/story_response.dart';

class StoryDetails extends StatefulWidget {
  final int storyId;

  const StoryDetails({super.key, required this.storyId});

  @override
  State<StoryDetails> createState() => _StoryDetailsState();
}

class _StoryDetailsState extends State<StoryDetails> {
  @override
  void initState() {
    super.initState();

    context.read<StoryCubit>().getStory(widget.storyId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text(
            'Story Details',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<StoryCubit, StoryState>(
          listener: (context, state) {
            state.whenOrNull(
              error: (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error loading story: $error')),
                );
              },
            );
          },
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: Text('Initializing...')),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (data) {
                final StoryResponse storyResponse = data as StoryResponse;
                final Story? story = storyResponse.story?.firstOrNull;

                if (story == null) {
                  return const Center(
                    child: Text('Story not found or data is incomplete.'),
                  );
                }

                final dynamic rawSubQuestions = story.test?.subQuestionsCount;
                final String subQuestionsValue = (rawSubQuestions ?? 0)
                    .toString();

                final dynamic rawQuantity = story.quantity;
                final String quantityValue = (rawQuantity ?? 0).toString();

                final dynamic rawAllowedBorrowDays = story.allowedBorrowDays;
                final String allowedBorrowDaysValue =
                    (rawAllowedBorrowDays ?? 0).toString();

                return SingleChildScrollView(
                  child: SafeArea(
                    child: Column(
                      children: [
                        const SizedBox(height: 70.0),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 180.0,
                                height: 250.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: Colors.amber,
                                      width: 4.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      story.coverUrl ??
                                          'assets/images/bookCover.jpg',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                                'assets/images/bookCover.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              IconButton(
                                icon: const Icon(
                                  Icons.qr_code_scanner_rounded,
                                  color: Colors.blueGrey,
                                  size: 35.0,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40.0),

                        _buildInfoCard('Title', story.title ?? 'N/A'),
                        const SizedBox(height: 15.0),

                        _buildInfoCard('Sub-Questions', subQuestionsValue),
                        const SizedBox(height: 15.0),

                        _buildInfoCard('Quantity', quantityValue),
                        const SizedBox(height: 15.0),

                        _buildInfoCard(
                          'Allowed borrow days',
                          allowedBorrowDaysValue,
                        ),
                        const SizedBox(height: 40.0),
                        SizedBox(
                          width: 190.0,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            child: const Text(
                              'Show Quiz',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              error: (error) =>
                  Center(child: Text('Failed to load story: $error')),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.deepPurple,
          mini: true,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.amber, width: 2.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
