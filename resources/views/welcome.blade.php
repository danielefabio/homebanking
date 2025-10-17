<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{ $app_name }}</title>
  @vite('resources/css/app.css')
</head>
<body class="bg-gradient-to-br from-blue-900 via-blue-600 to-purple-700 text-white min-h-screen flex flex-col">

  <!-- Header -->
  <header class="flex justify-between items-center px-8 py-4 bg-transparent">
    <div class="flex items-center space-x-2">
      <div class="bg-white text-blue-700 font-bold px-2 py-1 rounded">HB</div>
      <span class="font-semibold text-lg">{{ $app_name }}</span>
    </div>
    <nav class="space-x-6">
      @if(Route::has('login'))
        <a href="{{ route('login') }}" class="hover:text-gray-200">@lang('welcome.login')</a>
      @endif
      @if(Route::has('register'))
        <a href="{{ route('register') }}" class="bg-white text-blue-700 px-4 py-2 rounded hover:bg-gray-100">@lang('welcome.register')</a>
      @endif
    </nav>
  </header>

  <!-- Hero -->
  <section class="flex flex-col items-center justify-center text-center flex-grow px-6 py-16">
    <h1 class="text-4xl md:text-5xl font-bold mb-4">@lang('welcome.title', ['app_name' => $app_name])</h1>
    <p class="text-lg md:text-xl text-gray-200 max-w-2xl mb-10">@lang('welcome.description')</p>

    <!-- Features -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-5xl w-full">
      <div class="bg-white/10 backdrop-blur-md rounded-lg p-6 shadow hover:shadow-lg transition">
        <h3 class="text-xl font-semibold mb-2">💳 @lang('welcome.features.check.title')</h3>
        <p class="text-gray-200">@lang('welcome.features.check.description')</p>
      </div>
      <div class="bg-white/10 backdrop-blur-md rounded-lg p-6 shadow hover:shadow-lg transition">
        <h3 class="text-xl font-semibold mb-2">⚡ @lang('welcome.features.fast.title')</h3>
        <p class="text-gray-200">@lang('welcome.features.fast.description')</p>
      </div>
      <div class="bg-white/10 backdrop-blur-md rounded-lg p-6 shadow hover:shadow-lg transition">
        <h3 class="text-xl font-semibold mb-2">🔒 @lang('welcome.features.secure.title')</h3>
        <p class="text-gray-200">@lang('welcome.features.secure.description')</p>
      </div>
    </div>

    <!-- Call to Action -->
    <div class="mt-12">
      @if(Route::has('register'))
        <a href="{{ route('register') }}" class="bg-white text-blue-700 font-semibold px-6 py-3 rounded-lg shadow hover:bg-gray-100 transition">
          @lang('welcome.register_now')
        </a>
      @endif
    </div>
  </section>

  <!-- Demo -->
  <section class="px-6 py-16 text-center">
    <h2 class="text-3xl font-bold mb-8">@lang('welcome.demo_title')</h2>
    <img src="/images/hb_dashboard.jpeg" alt="Dashboard" class="mx-auto rounded-xl shadow-lg max-w-3xl opacity-65 hover:opacity-60 transition">
  </section>

  <!-- Testimonianze -->
  <section class="px-6 py-16 max-w-7xl mx-auto">
    <h2 class="text-3xl font-bold text-center mb-12">@lang('welcome.testimonials_title')</h2>
    <div class="grid md:grid-cols-3 gap-8">
      <div class="bg-white/10 backdrop-blur-md p-6 rounded-lg shadow">
        <p class="italic">“@lang('welcome.testimonials.1')”</p>
        <span class="block mt-4 font-semibold">— Maria R.</span>
      </div>
      <div class="bg-white/10 backdrop-blur-md p-6 rounded-lg shadow">
        <p class="italic">“@lang('welcome.testimonials.2')”</p>
        <span class="block mt-4 font-semibold">— Luca B.</span>
      </div>
      <div class="bg-white/10 backdrop-blur-md p-6 rounded-lg shadow">
        <p class="italic">“@lang('welcome.testimonials.3')”</p>
        <span class="block mt-4 font-semibold">— Giulia F.</span>
      </div>
    </div>
  </section>

  <!-- FAQ -->
  <section class="px-6 py-16 max-w-4xl mx-auto">
    <h2 class="text-3xl font-bold text-center mb-12">@lang('welcome.faq_title')</h2>
    <div class="space-y-6 text-left">
      <div>
        <h3 class="font-semibold">Q: @lang('welcome.faq.1.q')</h3>
        <p class="text-gray-200">A: @lang('welcome.faq.1.a')</p>
      </div>
      <div>
        <h3 class="font-semibold">Q: @lang('welcome.faq.2.q')</h3>
        <p class="text-gray-200">A: @lang('welcome.faq.2.a')</p>
      </div>
      <div>
        <h3 class="font-semibold">Q: @lang('welcome.faq.3.q')</h3>
        <p class="text-gray-200">A: @lang('welcome.faq.3.a')</p>
      </div>
    </div>
  </section>

  <!-- Footer -->
  <footer class="text-center py-6 text-gray-300 text-sm">
    @lang('welcome.footer', ['year' => date('Y'), 'app_name' => $app_name])
  </footer>

</body>
</html>