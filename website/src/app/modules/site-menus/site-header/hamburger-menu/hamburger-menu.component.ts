import { animate, query, stagger, state, style, transition, trigger, group } from '@angular/animations';
import { Component, Input } from '@angular/core';
import { PageLink } from '@src/app/classes/pagelink';

@Component({
  selector: 'app-hamburger-menu',
  templateUrl: './hamburger-menu.component.html',
  styleUrls: ['./hamburger-menu.component.css'],
  animations: [
    trigger('openClose', [
      // ...
      state(
        'open',
        style({
          opacity: 1,
        }),
      ),
      state(
        'closed',
        style({
          opacity: 0,
          pointerEvents: 'none',
        }),
      ),
      transition('open => closed', [animate('100ms ease-in')]),
      transition('closed => open', [
        group([
          animate('200ms ease-out'),
          query('.dropdown-content>*', [
            style({ opacity: 0, transform: 'translateX(-100px)' }),
            stagger(10, [animate('500ms cubic-bezier(0.35, 0, 0.25, 1)', style({ opacity: 1, transform: 'none' }))]),
          ]),
        ]),
      ]),
    ]),
  ],
})
export class HamburgerMenuComponent {
  @Input() pageLinks: PageLink[] = [];

  expanded: boolean = false;

  get openCloseTrigger() {
    return this.expanded ? 'open' : 'closed';
  }
}
