---
title: "Type-Safe Shared Data and Page Props in Inertia.js - Laravel News"
source: "https://laravel-news.com/type-safe-shared-data-and-page-props-in-inertiajs?bento_uuid=2895b17f-fff8-4626-a29b-6ca3d7c4db87"
author:
  - "[[Laravel News]]"
published: 2025-02-25
created: 2025-03-02
description: "Working with Inertia.js is amazing, but managing shared data types between your Laravel backend and JavaScript frontend can quickly become unwieldy. In this post, I'll show you how to leverage Laravel Data DTOs and TypeScript to create a type-safe, maintainable system for handling both global shared data and page-specific props."
tags:
  - "clippings"
---
If you follow me, you know I've been working extensively with React/Inertia and loving it. Today, I want to share a technique I use in all my Inertia.js projects that works with React, Vue, or any JavaScript framework: typing your shared data and page props.

## What is shared data?

In Inertia.js, shared data is defined in your `HandleInertiaRequests` middleware `share()` method. This data is available on every request from your backend to your frontend, essentially making it "global." Since this data appears everywhere, understanding its structure is crucial.

For example, you might share user data on each request. This user data can either exist or not, depending on the authentication state. But how do you best define and track this data structure? The answer: Laravel Data DTOs and TypeScript!

## Page-specific props

Beyond global shared data, most requests also include page-specific props. While some pages might rely solely on global data, most return additional information specific to that page. This could include:

- Metadata for page titles
- SEO tags for your `<head/>` element
- Breadcrumb navigation paths
- Page-specific content

As your app grows and your team expands, you'll want clear visibility into this data without constantly switching contexts to check your models.

I recently gave a talk at the [Laravel Worldwide Meetup](https://www.youtube.com/watch?v=enuJ5wE33dY) about typing data using Spatie's Laravel Data and TypeScript Transformer packages. Building on that foundation, let's explore how to type both global shared data and page-specific props, accessing them through hooks rather than passing them directly to page components.

## The problem I want to solve in my application

*For the sake of this example, I am going to leave out the full details of the Models and migrations, but you can imagine a simple example of this with a needing a Team's `name` for display and an `ID` to be able to switch the user in and out of a team.*

In my application, my users can be on many teams. I want to allow them to be able to switch teams and see all the teams they currently are a part of.

I am also going to have a breadcrumb that I want to define and return from my controllers, this data will be contextual to the controller and view I am returning so although this is *global* data, it is not something We can define it easily in the Inertia Middleware, so we will just do it from our controller.

So you can see that there will be a small team switching component needed in our application layout, along with the breadcrumbs.

## So why is this a problem?

The data coming from my applications backend will need to reach some child components. If you imagine your app layout as the parent component for all of these other child components you will need to figure out a way of getting the data to them, somehow from the shared props, for the user information and team information, as well as the page props for the breadcrumb component.

To do this, you have a few options:

- You can prop drill, accept the props in a parent component, and keep passing it down the child hierarchy until you get it where you need it. 🤢
- You can just not have a child component and have all your component logic in the same file.🤮
- You can use a hook with typed page props to access your shared data, as well as your per page prop data anywhere in your application, like a boss. 🧠

## Let's dive into the code

Now, let's say in your application, this is what your global shared data looks like. We will be using Spatie's Laravel Data to define our returns.

In your `HandleInertiaRequests` middleware, you are going to be sharing the following data.

```php
class InertiaShareData extends Data{   public function __construct(       public readonly ?InertiaAuthData $auth,       /** null|array<string,string> */       public array|string|AlwaysProp|null $errors = null,   ) {   }}
```

In the above, we've defined our data to be comprised of the `$errors` that will come from any `422` validation redirect along with some `InertiaAuthData`, now this data is not always going to be present since we may or may not have an authed user, for example, sign up and registration pages.

Below, we have our authed data that will give us information about our current authed user, the current team they're viewing their data scoped by, along with a collection of other teams they are a part of.

```php
class InertiaAuthData extends Data{   public function __construct(       public readonly ?UserData $user,       public readonly TeamData|Optional|null $currentTeam,       #[DataCollectionOf(TeamData::class)]       public readonly DataCollection|Optional|null $teams,   ) {   }}
```

Then, in your Inertia middleware, you can use these types to ensure your shared data is properly structured:

```php
class HandleInertiaRequests extends Middleware{   public function share(Request $request): InertiaShareData   {       return InertiaShareData::from(           array_merge(               parent::share($request),               $this->authData($request),           )       );   }   private function authData(Request $request): array   {       if ($user = $request->user()) {           $user->loadMissing(['teams']);           return [               'auth' => [                   'user' => UserData::from($user),                   'currentTeam' => TeamData::optional($user->currentTeam),                   'teams' => TeamData::collect($user->teams),               ],           ];       }       return ['auth' => null];   }}
```

So, with the above setup, every request through our applications middleware will return this data to our front end. Now, let's look at what our controllers will share to display the breadcrumb data.

```php
class DashboardController{    public function __invoke(): \Inertia\Response    {        return inertia('dashboard/index', [            'meta' => [                'title' => 'Dashboard',                'breadcrumbs' => [                    [                        'url' => route('dashboard.show'),                        'label' => 'Dashboard',                    ],                ],            ],            // other data you may need        ]);    }}
```

## Define the types

The beauty of using Laravel Data is with an additional package the PHP DTO's we created to pass around our data can be transformed to TypeScript type definitions.

This is an incredible feature, but we still need to define a few more things to be able to take full advantage of typed shared and page props.

In `/resources/js/types/` you can create a `global.d.ts` file. The `.d.ts` extension stands for "declaration file" in TypeScript. These files are used to provide type information for JavaScript code or to define ambient types that are available throughout your project. They don't contain implementations - only type declarations to help with auto-complete and linting.

What we want to do is to instruct TypeScript that in our application when referencing the Inertia PageProps, what shape and type of data we expect to be working with.

```typescript
// -/resources/js/types/global.d.tsimport { PageProps as InertiaPageProps } from '@inertiajs/core'export type PageProps<  T extends Record<string, unknown> | unknown[] = Record<string, unknown> | unknown[]> = App.Data.InertiaSharedData & T;declare module '@inertiajs/core' {  interface PageProps extends InertiaPageProps, AppPageProps {}}
```

In `/resources/js/types/global.d.ts`, we're extending Inertia's type system. The `PageProps` type we're creating combines our shared data (`App.Data.InertiaSharedData`) with any additional page-specific props (`T`). We're also augmenting Inertia's built-in `PageProps` interface to include our custom types.

Now, let's create a hook that will make it easy to access both our shared props and any page-specific data (like `meta`) with full-type safety.

```typescript
// -/resources/js/composables/use-typed-page-props.tsimport { usePage } from '@inertiajs/react';import type { PageProps } from '@/types/global';export function useTypedPageProps<  T extends Record<never, never> | unknown[] = Record<never, never> | unknown[]>() {  return usePage<PageProps<T>>();}
```

This hook is a wrapper around Inertia's usePage hook that adds strong typing, let's explain each line.

```typescript
export function useTypedPageProps<  // T is a generic type parameter that defaults to an empty record or array  T extends Record<never, never> | unknown[] = Record<never, never> | unknown[]>() {  // Returns usePage with our PageProps type (shared data) combined with any page-specific props (T)  return usePage<PageProps<T>>();}
```

## Now we're ready!

## Making It Easy to Use: Custom Hooks

Now, here's where it gets really cool. Instead of accessing the shared data directly, we can create a custom hook that provides proper typing:

```typescript
// -resources/js/composables/use-auth.tsimport type { PageProps } from '@/types/global';import { useTypedPageProps } from '@/composables/use-typed-page-props';export function useAuth(): App.Data.UserData { const {   auth: { user } } = useTypedPageProps<PageProps>().props; return user as unknown as App.Data.UserData;}export function useCurrentTeam(): App.Data.TeamData { const {   auth: { currentTeam } } = useTypedPageProps<PageProps>().props; return currentTeam as unknown as App.Data.TeamData;}export function useTeams(): App.Data.TeamData[] { const {   auth: { teams } } = useTypedPageProps<PageProps>().props; return teams as unknown as App.Data.TeamData[];}
```

Now you can use it in your components like this:

```typescript
function UserProfile() {  const user = useAuth();  return (    <div>      <h1>Welcome, {user.name}!</h1>      {user.company && <p>Company: {user.company.name}</p>}    </div>  );}
```

## Handling Page-Specific Metadata

You can also use this pattern for page-specific metadata. Here's an example of how to type and use metadata in your pages:

```typescript
interface Metadata {  title: string;  breadcrumbs: {    label: string;    url: string;  }[];}// In your component:const { meta } = useTypedPageProps<{ meta: Metadata }>().props;// Now you get full type completion for your metadata!console.log(meta.title);meta.breadcrumbs.map(crumb => crumb.url);
```

Now lets look at how we can drop in a breadcrumb component using the above code.

```tsx
// Breadcrumbs.tsximport { Link } from '@inertiajs/react';import { ChevronRight, Home } from 'lucide-react';import { useTypedPageProps } from '@/composables/use-typed-page-props';interface BreadcrumbMeta {  meta: {    title: string;    breadcrumbs: {      label: string;      url: string;    }[];  };}export function Breadcrumbs() {  const { meta } = useTypedPageProps<BreadcrumbMeta>().props;  return (    <nav className="flex items-center space-x-1 text-sm text-gray-500">      <Link href="/dashboard" className="flex items-center hover:text-blue-600">        <Home className="h-4 w-4" />      </Link>      {meta.breadcrumbs.map((crumb, index) => (        <div key={crumb.url} className="flex items-center">          <ChevronRight className="h-4 w-4 mx-1" />          {index === meta.breadcrumbs.length - 1 ? (            <span className="font-medium text-gray-900">{crumb.label}</span>          ) : (            <Link              href={crumb.url}              className="hover:text-blue-600"            >              {crumb.label}            </Link>          )}        </div>      ))}    </nav>  );}
```

How cool is that?

## Okay, but what about Vue?

This is the best part about this approach, it's completely framework-agnostic. While I think React has a much much easier and cleaner integration with TypeScript, you can use the exact same hooks in Vue.

Since Vue is a big part of Laravel, here's an example for you!

```vue
<!-- Breadcrumbs.vue --><script setup lang="ts">import { Link } from '@inertiajs/vue3'import { ChevronRight, Home } from 'lucide-vue-next'import { useTypedPageProps } from '@/composables/use-typed-page-props'interface BreadcrumbMeta {  meta: {    title: string;    breadcrumbs: {      label: string;      url: string;    }[];  };}const { meta } = useTypedPageProps<BreadcrumbMeta>().props // this does not change!</script><template>  <nav class="flex items-center space-x-1 text-sm text-gray-500">    <Link href="/dashboard" class="flex items-center hover:text-blue-600">      <Home class="h-4 w-4" />    </Link>    <div v-for="(crumb, index) in meta.breadcrumbs" :key="crumb.url" class="flex items-center">      <ChevronRight class="h-4 w-4 mx-1" />      <span        v-if="index === meta.breadcrumbs.length - 1"        class="font-medium text-gray-900"      >        {{ crumb.label }}      </span>      <Link        v-else        :href="crumb.url"        class="hover:text-blue-600"      >        {{ crumb.label }}      </Link>    </div>  </nav></template>
```

## This post needs more cowbell, let's step things up a bit.

As amazing as this is, this is a smaller, simpler example. Let's try something a bit more challenging. Let's create a component that shows the current user a list of their teams and their current team in a Shadcn popover and combobox! This will be our team switcher.

```tsx
// TeamSwitcher.tsximport { useEffect, useState } from 'react';import { Check, ChevronsUpDown } from 'lucide-react';import { useCurrentTeam, useTeams } from '@/composables/use-auth';import { Button } from '@/components/ui/button';import {  Command,  CommandEmpty,  CommandGroup,  CommandInput,  CommandItem,} from '@/components/ui/command';import {  Popover,  PopoverContent,  PopoverTrigger,} from '@/components/ui/popover';import { router } from '@inertiajs/react';import { cn } from '@/lib/utils';export function TeamSwitcher() {  const [open, setOpen] = useState(false);  const currentTeam = useCurrentTeam(); // this will give us the current team data from the global shared data  const teams = useTeams(); // this will give us all the users teams, also from the global data  // Handle team switching  const switchTeam = (teamId: number) => {    router.post(route('teams.switch'), {      team_id: teamId    }, {      preserveScroll: true,      onSuccess: () => setOpen(false)    });  };  return (    <Popover open={open} onOpenChange={setOpen}>      <PopoverTrigger asChild>        <Button          variant="outline"          role="combobox"          aria-expanded={open}          className="w-[200px] justify-between"        >          {currentTeam?.name ?? "Select team..."}          <ChevronsUpDown className="ml-2 h-4 w-4 shrink-0 opacity-50" />        </Button>      </PopoverTrigger>      <PopoverContent className="w-[200px] p-0">        <Command>          <CommandInput placeholder="Search teams..." />          <CommandEmpty>No team found.</CommandEmpty>          <CommandGroup>            {teams.map((team) => (              <CommandItem                key={team.id}                value={team.name}                onSelect={() => switchTeam(team.id)}              >                <Check                  className={cn(                    "mr-2 h-4 w-4",                    currentTeam?.id === team.id ? "opacity-100" : "opacity-0"                  )}                />                {team.name}              </CommandItem>            ))}          </CommandGroup>        </Command>      </PopoverContent>    </Popover>  );}
```

Notice how this component is completely self-sufficient and will not and does not require any parent component to pass in data to properly render and work?

Also, in your code, you can access autocomplete functionality for every single available piece of data defined in your DTO.

Let's see what it would look like to implement these components in our app layout.

```tsx
// AppLayout.tsximport { PropsWithChildren } from 'react';import { TeamSwitcher } from '@/components/TeamSwitcher';import { Breadcrumbs } from '@/components/Breadcrumbs';import { useAuth } from '@/composables/use-auth';export default function AppLayout({ children }: PropsWithChildren) {  const user = useAuth();  return (    <div className="min-h-screen bg-gray-50">      <header className="bg-white shadow">        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">          <div className="flex justify-between items-center">            <h1 className="text-xl font-semibold">My App</h1>            <div className="flex items-center space-x-4">              {user && <TeamSwitcher />}              <div>                Welcome, {user?.name}              </div>            </div>          </div>          <div className="mt-4">            <Breadcrumbs />          </div>        </div>      </header>      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">        {children}      </main>    </div>  );}
```

Now, be honest, how clean and easy to read is that code? Also, notice we can use that same `useAuth` hook to get the user in the app layout again like a boss. 😎

## Final Thoughts

This pattern has dramatically improved how we handle shared data in our Inertia applications. Not only does it make the code more maintainable, but it also helps catch potential issues before they reach production.

1. **Type Safety**: You get full TypeScript support for your shared data
2. **Better Developer Experience**: Auto-completion and type hints make development faster
3. **Easier Refactoring**: When you need to change shared data structure, TypeScript will help you find all the places that need updates
4. **Cleaner Code**: No more type assertions or guessing what properties are available
5. **More flexible UI components**: Drop in functionality for any component that requires data

Remember, the goal here isn't just type safety - it's about making your codebase more maintainable and your development experience more enjoyable. Happy coding! 🚀