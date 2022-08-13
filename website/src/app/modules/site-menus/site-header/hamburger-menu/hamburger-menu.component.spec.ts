import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HamburgerMenuComponent } from './hamburger-menu.component';

describe('HamburgerMenuComponent', () => {
  let component: HamburgerMenuComponent;
  let fixture: ComponentFixture<HamburgerMenuComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [HamburgerMenuComponent],
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(HamburgerMenuComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
