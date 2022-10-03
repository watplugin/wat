import { Component, EventEmitter, Input, Output } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-text-button',
  templateUrl: './text-button.component.html',
  styleUrls: ['./text-button.component.css'],
})
export class TextButtonComponent {
  @Output() click = new EventEmitter();

  @Input() link: string = '';
  @Input() color: string = 'primary';

  constructor(private router: Router) {}

  onClick() {
    if (this.link) this.router.navigateByUrl(this.link);
    this.click.emit();
  }
}
