import 'dart:convert';

class FeedModel {
  final int page;
  final int maxPageSize;
  final int pageSize;
  final List<Post> posts;

  FeedModel({
    required this.page,
    required this.maxPageSize,
    required this.pageSize,
    required this.posts,
  });

  factory FeedModel.fromRawJson(String str) =>
      FeedModel.fromJson(json.decode(str));

  factory FeedModel.fromJson(Map<String, dynamic> json) => FeedModel(
    page: json["page"],
    maxPageSize: json["max_page_size"],
    pageSize: json["page_size"],
    posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
  );
}

class Post {
  final int id;
  final List<dynamic>? category;
  final String slug;
  final dynamic parentVideoId;
  final int childVideoCount;
  final String title;
  final String identifier;
  final int commentCount;
  final int upvoteCount;
  final int viewCount;
  final int shareCount;
  final int tagCount;
  final String videoLink;
  final bool isLocked;
  final int createdAt;
  final String firstName;
  final String lastName;
  final String username;
  final bool upvoted;
  final bool bookmarked;
  final String thumbnailUrl;
  final bool following;
  final String pictureUrl;
  final int votingCount;
  final List<dynamic> votings;
  final List<dynamic> tags;

  Post({
    required this.id,
    this.category,
    required this.slug,
    required this.parentVideoId,
    required this.childVideoCount,
    required this.title,
    required this.identifier,
    required this.commentCount,
    required this.upvoteCount,
    required this.viewCount,
    required this.shareCount,
    required this.tagCount,
    required this.videoLink,
    required this.isLocked,
    required this.createdAt,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.upvoted,
    required this.bookmarked,
    required this.thumbnailUrl,
    required this.following,
    required this.pictureUrl,
    required this.votingCount,
    required this.votings,
    required this.tags,
  });

  factory Post.fromRawJson(String str) => Post.fromJson(json.decode(str));

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    category: ["category"],
    slug: json["slug"],
    parentVideoId: json["parent_video_id"],
    childVideoCount: json["child_video_count"],
    title: json["title"],
    identifier: json["identifier"],
    commentCount: json["comment_count"],
    upvoteCount: json["upvote_count"],
    viewCount: json["view_count"],
    shareCount: json["share_count"],
    tagCount: json["tag_count"],
    videoLink: json["video_link"],
    isLocked: json["is_locked"],
    createdAt: json["created_at"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    username: json["username"],
    upvoted: json["upvoted"],
    bookmarked: json["bookmarked"],
    thumbnailUrl: json["thumbnail_url"],
    following: json["following"],
    pictureUrl: json["picture_url"],
    votingCount: json["voting_count"],
    votings: List<dynamic>.from(json["votings"].map((x) => x)),
    tags: List<dynamic>.from(json["tags"].map((x) => x)),
  );
}
