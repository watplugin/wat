import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FullPageHeaderComponent } from './full-page-header.component';

describe('FullPageHeaderComponent', () => {
  let component: FullPageHeaderComponent;
  let fixture: ComponentFixture<FullPageHeaderComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [FullPageHeaderComponent],
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(FullPageHeaderComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
