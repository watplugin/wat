import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ColumnLayoutComponent } from './column-layout.component';

describe('ColumnLayoutComponent', () => {
  let component: ColumnLayoutComponent;
  let fixture: ComponentFixture<ColumnLayoutComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ColumnLayoutComponent],
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ColumnLayoutComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
