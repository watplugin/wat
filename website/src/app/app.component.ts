import { Component, ElementRef, OnDestroy } from '@angular/core';
import { SettingsService } from '@src/_settings';
import { IconService } from '@visurel/iconify-angular';
import { Subject } from 'rxjs';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
})
export class AppComponent implements OnDestroy {
  title = 'cogs';
  showSidebars = false;

  onDestroy$ = new Subject<void>();

  constructor(private elementRef: ElementRef, iconService: IconService, settings: SettingsService) {
    iconService.registerAll(settings.General.icons);
    this.updateStyleVars();
  }

  ngOnDestroy(): void {
    this.onDestroy$.next();
    this.onDestroy$.complete();
  }

  updateStyleVars() {
    if (this.showSidebars) {
      this.elementRef.nativeElement.style.setProperty('--main-width', `min(80%, 1080px)`);
      this.elementRef.nativeElement.style.setProperty('--content-width', `100%`);
    } else {
      this.elementRef.nativeElement.style.setProperty('--main-width', `unset`);
      this.elementRef.nativeElement.style.setProperty('--content-width', `unset`);
    }
  }

  getOutletContainerStyle() {
    if (this.showSidebars)
      return {
        'flex-basis': 'var(--main-width)',
      };
    return {
      width: '100%',
    };
  }
}
