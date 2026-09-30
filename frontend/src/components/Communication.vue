<template>
  <div class="communication-page">
    <header>
      <h1>Time Manager</h1>
      <p>Communication Center</p>
    </header>

    <main>
      <section class="intro">
        <h2>Making Time Manager Easy to Use</h2>
        <p>
          Our goal is to help everyone understand Time Manager,
          answer their concerns, and make the transition simple.
        </p>
      </section>

      <section class="actions">
        <h2>Communication Actions</h2>

        <div class="cards">

          <article class="card">
            <div class="icon">📘</div>
            <h3>Employee Tutorial</h3>
            <p>
              A simple step-by-step tutorial explaining how to
              clock in, clock out, and check working time.
            </p>
            <span class="audience">Audience: Employees</span>
          </article>

          <article class="card">
            <div class="icon">📊</div>
            <h3>Manager Newsletter</h3>
            <p>
              A newsletter explaining how managers can monitor
              working time and follow their team's activity.
            </p>
            <span class="audience">Audience: Managers</span>
          </article>

          <article class="card">
            <div class="icon">📋</div>
            <h3>Administrator Guide</h3>
            <p>
              A practical guide explaining user management,
              system monitoring, and administration features.
            </p>
            <span class="audience">Audience: Administrators</span>
          </article>

          <article class="card">
            <div class="icon">📢</div>
            <h3>Awareness Campaign</h3>
            <p>
              Posters and short messages explaining the benefits
              of Time Manager and answering common concerns.
            </p>
            <span class="audience">Audience: All employees</span>
          </article>

          <article class="card">
            <div class="icon">🎥</div>
            <h3>Video Demonstration</h3>
            <p>
              A short video showing how simple the application is
              and demonstrating the main features.
            </p>
            <span class="audience">Audience: All users</span>
          </article>

          <article class="card">
            <div class="icon">✉️</div>
            <h3>Email Campaign</h3>
            <p>
              Informative emails answering questions about the
              application and explaining the transition.
            </p>
            <span class="audience">Audience: All employees</span>
          </article>

        </div>
      </section>

      <section class="message">
        <h2>Our Message</h2>
        <p>
          Time Manager is designed to make working-time management
          easier, clearer, and more transparent for everyone.
        </p>

        <button>
          Discover Time Manager
        </button>
      </section>
    </main>
  </div>
</template>

<style scoped>
.communication-page {
  min-height: 100vh;
  background: #f5f7fa;
  font-family: Arial, sans-serif;
  color: #222;
}

header {
  background: #1f2937;
  color: white;
  padding: 25px 40px;
}

header h1 {
  margin: 0;
}

header p {
  margin: 5px 0 0;
}

main {
  max-width: 1000px;
  margin: 40px auto;
  padding: 0 20px;
}

.intro,
.actions,
.message {
  background: white;
  padding: 30px;
  margin-bottom: 25px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.intro h2,
.actions h2,
.message h2 {
  margin-top: 0;
}

.intro p,
.message p {
  line-height: 1.6;
}

.cards {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
}

.card {
  background: #f3f4f6;
  padding: 25px;
  border-radius: 10px;
}

.icon {
  font-size: 32px;
  margin-bottom: 10px;
}

.card h3 {
  margin: 5px 0 10px;
}

.card p {
  line-height: 1.5;
}

.audience {
  display: inline-block;
  margin-top: 10px;
  padding: 6px 10px;
  border-radius: 15px;
  background: #e5e7eb;
  font-size: 13px;
}

.message {
  text-align: center;
}

button {
  padding: 12px 25px;
  border: none;
  border-radius: 8px;
  background: #2563eb;
  color: white;
  cursor: pointer;
  font-size: 15px;
}

@media (max-width: 700px) {
  .cards {
    grid-template-columns: 1fr;
  }
}
</style>