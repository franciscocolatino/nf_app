import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { jobId: String } 
  static targets = ['status', 'progress', 'progressBar', 'errors'];

  apiUrl = `/jobs/${this.jobIdValue}`
  headers = { 'Accept': 'application/json' }

  connect() {
    this.startPolling();
  }

  startPolling() {
    this.pollingIntervalId = setInterval(() => {
      this.fetchJobStatus();
    }, 3000);
  }

  fetchJobStatus() {
    fetch(this.apiUrl, { headers: this.headers })
      .then(response => response.json())
      .then(data => {
        this.updateStatus(data.status);
        this.updateProgress(data.progress);
        this.updateErrors(data.errors);
        this.checkStopCondition(data.status);
      });
  }

  checkStopCondition(status) {
    if (status === 'done' || status === 'failure') {
      clearInterval(this.pollingIntervalId);
    }
  }

  updateStatus(status) {
    this.statusTarget.innerHTML = status;
  }

  updateProgress(progress) {
    this.progressTarget.innerHTML = progress;
    this.progressBarTarget.style.width = `${progress}%`;
  }

  updateErrors(errors) {
    this.errorsTarget.innerHTML = errors?.join(', ') || 'Nenhum.';
  }
}
