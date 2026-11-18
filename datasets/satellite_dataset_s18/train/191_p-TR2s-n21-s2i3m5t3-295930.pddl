(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	thermograph0 - mode
	thermograph1 - mode
	spectrograph4 - mode
	infrared2 - mode
	infrared3 - mode
	Star2 - direction
	Star0 - direction
	Star1 - direction
	Planet3 - direction
	Phenomenon4 - direction
	Phenomenon5 - direction
	Phenomenon6 - direction
	Star7 - direction
	Phenomenon8 - direction
)
(:init
	(supports instrument0 spectrograph4)
	(supports instrument0 infrared3)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star2)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 Star1)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon6)
	(supports instrument2 infrared3)
	(supports instrument2 infrared2)
	(calibration_target instrument2 Star2)
	(supports instrument3 spectrograph4)
	(supports instrument3 infrared3)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 Star0)
	(supports instrument4 thermograph1)
	(supports instrument4 infrared3)
	(calibration_target instrument4 Star1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon6)
)
(:goal (and
	(pointing satellite0 Phenomenon4)
	(pointing satellite1 Phenomenon8)
	(have_image Planet3 infrared3)
	(have_image Phenomenon4 thermograph1)
	(have_image Phenomenon5 infrared2)
	(have_image Phenomenon6 infrared2)
	(have_image Star7 thermograph0)
	(have_image Phenomenon8 thermograph0)
))

)
