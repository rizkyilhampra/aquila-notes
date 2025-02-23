---
title: "Fan-Out and Fan-In Patterns: Building a Personalized Feed in Laravel"
source: https://medium.com/@vagelisbisbikis/fan-out-and-fan-in-patterns-building-a-personalized-feed-in-laravel-676515f65e03
author: "[[Vagelis Bisbikis]]"
published: 2025-02-10
created: 2025-02-24
description: In modern applications, handling concurrent tasks efficiently is crucial for scalability and responsiveness. The Fan-Out and Fan-In patterns provide a structured approach to distributing and…
tags:
  - clippings
  - laravel
  - design-pattern
---
![](https://miro.medium.com/v2/resize:fit:1000/1*Y2cAXKcNDc4HhrbR7JZM-w.png)

[

![Vagelis Bisbikis](https://miro.medium.com/v2/resize:fill:88:88/1*Flf0EyHXxyFnS0_M2c8Q5w.jpeg)

](https://medium.com/@vagelisbisbikis?source=post_page---byline--676515f65e03---------------------------------------)

In modern applications, handling concurrent tasks efficiently is crucial for scalability and responsiveness. The **Fan-Out and Fan-In** patterns provide a structured approach to distributing and aggregating workloads. In this article, we’ll explore these patterns and implement a Laravel (PoC) to create a personalized user feed using an abstract caching layer powered by Redis.

## Understanding Fan-Out and Fan-In

## Fan-Out

Fan-Out is a pattern where a single task or event is split into multiple parallel tasks that can be executed independently. This pattern is especially useful in distributed systems and event-driven architectures, as it enables scalability and concurrency.

**How It Works:**

1. A producer emits an event or task.
2. Multiple workers, services, or microservices pick up the task for processing independently.
3. Each consumer performs its processing without depending on others.

**Example Scenario:** When a user performs an action in a gaming system (e.g., winning a game), multiple processes may be triggered:

- Notify the player’s friends.
- Update the leaderboard.
- Grant rewards.

This means that several topics of the application can act upon a single event without holding up the primary flow.

## Fan-In

Fan-In is the opposite of Fan-Out, where multiple parallel tasks finish their execution, and their results are combined into a single final result.

**How It Works:**

1. Multiple concurrent tasks execute independently and produce results.
2. The system waits for all tasks to finish.
3. The results are collected, merged, or computed into a final aggregated response.

**Example Scenario:** In the context of a personalized feed system:

- Different activities (game actions, leaderboard updates, friend achievements) are stored separately.
- The system periodically fetches and merges these updates.
- The user sees a unified and ordered feed of relevant events.

## Fan-Out and Fan-In Service Models

## Fan-Out Services

The purpose of Fan-Out services is to distribute a task among several consumers. They can be implemented in various ways:

## 1\. Fan-Out on Write (Push Model)

In this approach, when an event occurs, it gets **pushed immediately** to multiple destinations such as databases, message queues, and caches. This way, data is precomputed and ready when needed.

**Pros:**

- Low latency on reads since data is already distributed.
- Ensures data consistency across all consumers.

**Cons:**

- Can be inefficient if many updates happen frequently.
- Requires more storage since data needs to be precomputed for every user.

**Example Use Case:** A social media platform that does some computation ahead of time and pushes updates onto a user’s feed the instant an event occurs.

## 2\. Fan-Out on Read (Pull Model)

Instead of pushing data immediately, this model allows consumers to pull the latest data when needed. The system aggregates the required information **at query time**.

**Pros:**

- Saves storage by computing results only when requested.
- More effective when the system is one that reads less often than it writes.

**Cons:**

- Higher latency because data is fetched and computed upon request.
- Higher database or API load.

**Example Use Case:** A news aggregator fetching the latest articles from various sources **only** when a user requests them.

## Fan-In Services

Fan-In services are responsible for gathering results from multiple sources and returning one consolidated final response. Generally speaking, they do their jobs in one of two ways:

## 1\. Synchronous Fan-In

- Waits for all parallel tasks to complete before returning a final result.
- Suitable for scenarios where all tasks are required for completeness.

**Example:** Aggregating scores from different game servers before displaying the final leaderboard.

## 2\. Asynchronous Fan-In

- Collects partial results over time and updates the final result incrementally.
- Useful when real-time updates are preferred.

**Example:** Streaming platforms displaying partial analytics before a full report is ready.

## Use Cases for Fan-Out and Fan-In

1. **Notifications System:** A user action triggers notifications via email, push, and SMS.
2. **Analytics Processing:** Large-scale event data processing and aggregation.
3. **Real-Time Gaming Feeds:** Updating live leaderboards and personal feeds based on events.

## Hybrid Fan-Out and Fan-In Service Model for News Feeds

A hybrid approach can be used to combine the best of push and pull models while mitigating their downsides. In this strategy, **most users receive updates via a push mechanism**, ensuring low-latency feed updates, while **high-traffic users fetch content on-demand** to prevent system overload.

## How It Works:

**Push for Most Users:**

- When an event occurs (e.g., a user posts an update), the system **precomputes** and pushes the update to the feeds of most followers.
- This ensures that most users receive a low-latency experience when loading their feeds.

**Pull for High-Activity Users:**

- If a user follows **a large number of accounts**, pushing all updates in real-time can be resource-intensive.
- Instead, the system **indexes updates** but doesn’t push them immediately.
- When the user loads their feed, relevant updates are fetched dynamically (pull model).

## Advantages of the Hybrid Model:

- **Efficient resource utilization:** Reduces unnecessary push operations for users who may not engage frequently.
- **Scalability:** Balances system load by offloading intensive processing from peak users.
- **Optimized user experience:** Most users get instant feed updates, while high-traffic users don’t overwhelm the system.

## Proof of Concept (PoC): Personalized Feed System

## 1\. Architecture Overview

![](https://miro.medium.com/v2/resize:fit:1000/1*e9eRW7ahD2PbZRNK4nqFeQ.png)

This sequence diagram illustrates the **Fan-Out workflow** when a user posts an activity (e.g., winning a game):

1. The user triggers an action, which fires an `ActivityCreated` event in Laravel.
2. The system fetches the user’s followers from the database.
3. For each follower, the activity is either:

- **Pushed** directly to their Redis feed (stored as a sorted set `ZSET` for chronological ordering).
- **Indexed** in a Redis list (`LIST`) for on-demand fetching (pull model).  
This ensures high concurrency by offloading work to Redis and decoupling the activity distribution from the main application thread.

## 2\. Code Implementation

> ⚠️ **This Code is a Proof of Concept (PoC)**  
> The provided code demonstrates core concepts but is **not production-ready**. Key considerations for a real-world system include:  
> **Error Handling**: Retries for failed Redis operations, dead-letter queues for activities.  
> **Scalability**: Sharding Redis keys for users with massive follower counts.  
> **Security**: Validate user permissions before distributing activities.  
> **Monitoring**: Track Redis memory usage, queue backlogs, and feed latency.  
> **Data Consistency**: Cache invalidation for follower lists/activity updates.

![](https://miro.medium.com/v2/resize:fit:1000/1*CKRelsUqJYazCzeJxEMZcA.png)

Sequence Diagram of NewsFeed POC

**Step 1: NewsFeedService**

Handles distributing activities to followers using Redis.

```
namespace App\Services;use App\DTOs\ActivityDTO;
use Illuminate\Support\Facades\Redis;class NewsFeedService
{
    public function __construct(
        protected FollowersService $followersService,
        protected Redis $redis
    ) {}    public function distributeActivity(ActivityDTO $activity): void
    {
        $followers = $this->followersService->getFollowers($activity->userId);
        $threshold = config('feed.push_threshold');        
        $this->redis::pipeline(function ($pipe) use ($followers, $activity, $threshold) {
            foreach ($followers as $followerId) {
                if ($this->shouldPushFeed($activity->userId, $threshold)) {
                    $pipe->zadd("feed:{$followerId}", $activity->timestamp, json_encode($activity));
                } else {
                    $pipe->lpush("feed_index:{$followerId}", json_encode($activity));
                }
            }
        });
    }    private function shouldPushFeed(int $creatorId, int $threshold): bool
    {
        return $this->followersService->getFollowerCount($creatorId) < $threshold;
    }
}
```

**Step 2: FollowersService**

Fetches and caches follower data.

```
namespace App\Services;use Illuminate\Support\Facades\Cache;
use App\Repositories\FollowersRepository;class FollowersService
{
    public function __construct(
        protected FollowersRepository $repository,
        protected int $cacheTtl = 300
    ) {}    public function getFollowers(int $userId): array
    {
        return Cache::remember("followers:{$userId}", $this->cacheTtl, function () use ($userId) {
            return $this->repository->getFollowers($userId);
        });
    }
    public function getFollowerCount(int $userId): int
    {
        return (int) Cache::remember("follower_count:{$userId}", $this->cacheTtl, function () use ($userId) {
            return $this->repository->getFollowerCount($userId);
        });
    }
}
```

**Step 3: Event and Listener**

Triggers activity distribution.

```
namespace App\Events;use App\DTOs\ActivityDTO;class ActivityCreated
{
    use Dispatchable, SerializesModels;
    public function __construct(public ActivityDTO $activity) {}
}
namespace App\Listeners;use App\Events\ActivityCreated;
use App\Services\NewsFeedService;class DistributeActivity
{
    public function __construct(protected NewsFeedService $newsFeedService) {}        public function handle(ActivityCreated $event)
    {
        $this->newsFeedService->distributeActivity($event->activity);
    }
}
```

**Step 4: Fan-In Aggregation**

Merge feeds on read

```php
class NewsFeedService
{       public function getFeed(int $userId, int $limit = 50): array
    {
        $feed = [];
        $threshold = config('feed.push_threshold');
        
        if ($this->shouldPushFeed($userId, $threshold)) {
            $feed = $this->redis::zrevrange("feed:{$userId}", 0, $limit);
        } 
        
        else {
            $feed = $this->redis::lrange("feed_index:{$userId}", 0, $limit);
            $this->redis::ltrim("feed_index:{$userId}", $limit, -1);
        }
        return array_map('json_decode', $feed);
    }
}
```

## 3\. Key Features of the PoC

**Hybrid Model**:

- **Push (ZSET)**: Pre-sort activities by timestamp for low-latency access.
- **Pull (LIST)**: Dynamically fetch updates for high-traffic users.

**Redis Optimization**:

- **Pipelines**: Reduce Redis round-trips for bulk operations.
- **Sorted Sets (ZSET)**: Efficiently store and retrieve time-ordered feeds.

**Caching**:

- Cache follower lists and counts to avoid database overload.

## Conclusion

The Fan-Out and Fan-In patterns are indispensable tools for building scalable, responsive applications. By distributing workloads across parallel tasks (Fan-Out) and aggregating results efficiently (Fan-In), developers can optimize systems to handle real-time demands, such as personalized feeds in gaming or social platforms.

- **Hybrid Model**: Balances low-latency push updates for most users with on-demand pull strategies for high-traffic accounts.
- **Redis Optimization**: Leverages pipelines and sorted sets to reduce overhead and ensure chronological ordering.
- **Modular Design**: Separates concerns with services like `FollowersService` and event-driven workflows.

However, transitioning from PoC to production requires addressing:

- **Scalability**: Sharding Redis keys for users with millions of followers.
- **Resilience**: Dead-letter queues for failed activities, cache invalidation strategies.
- **User Experience**: Pagination, filtering, and ranking (e.g., prioritizing friend activities).

Incorporate tools like **Laravel Horizon** for queue monitoring and **Redis Cluster** for horizontal scaling to elevate this system to enterprise-grade reliability.

By mastering Fan-Out/Fan-In patterns, you empower applications to thrive under heavy loads while delivering seamless, real-time experiences — a critical advantage in today’s competitive digital landscape.