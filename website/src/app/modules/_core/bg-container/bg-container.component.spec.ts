import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BgContainerComponent } from './bg-container.component';

describe('BgContainerComponent', () => {
  let component: BgContainerComponent;
  let fixture: ComponentFixture<BgContainerComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [BgContainerComponent],
    }).compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(BgContainerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
