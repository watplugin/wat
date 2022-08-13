import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LogoTextButtonComponent } from './logo-text-button.component';

describe('LogoTextButtonComponent', () => {
  let component: LogoTextButtonComponent;
  let fixture: ComponentFixture<LogoTextButtonComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [LogoTextButtonComponent],
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(LogoTextButtonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
