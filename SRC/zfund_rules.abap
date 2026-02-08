FORM calculate_percentage
  USING    p_alloc TYPE p
           p_util  TYPE p
  CHANGING p_perc  TYPE p.

  IF p_alloc IS INITIAL.
    p_perc = 0.
  ELSE.
    p_perc = ( p_util / p_alloc ) * 100.
  ENDIF.

ENDFORM.


FORM classify_risk
  USING    p_perc TYPE p
           p_high TYPE p
           p_med  TYPE p
  CHANGING p_risk TYPE char10
           p_icon TYPE icon_d.

  IF p_perc > p_high.
    p_risk = 'HIGH'.
    p_icon = icon_red_light.
  ELSEIF p_perc >= p_med.
    p_risk = 'MEDIUM'.
    p_icon = icon_yellow_light.
  ELSE.
    p_risk = 'LOW'.
    p_icon = icon_green_light.
  ENDIF.

ENDFORM.
