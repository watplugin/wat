import { Component, HostListener, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-logo-text-button',
  templateUrl: './logo-text-button.component.html',
  styleUrls: ['./logo-text-button.component.css'],
})
export class LogoTextButtonComponent implements OnInit {
  hover: boolean = false;
  active: boolean = false;
  scrolled: boolean = false;

  constructor(private router: Router) {}

  ngOnInit(): void {}

  onClick() {
    this.router.navigateByUrl('home');
  }

  @HostListener('window:scroll', ['$event']) // for window scroll events
  onScroll() {
    this.scrolled = window.pageYOffset != 0;
  }
}
