(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	spectrograph1 - mode
	infrared3 - mode
	thermograph4 - mode
	infrared5 - mode
	spectrograph2 - mode
	spectrograph0 - mode
	GroundStation2 - direction
	GroundStation3 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation0 - direction
	GroundStation4 - direction
	Star5 - direction
	Star1 - direction
	Planet12 - direction
	Star13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph2)
	(supports instrument0 infrared3)
	(supports instrument0 infrared5)
	(supports instrument0 thermograph4)
	(calibration_target instrument0 GroundStation0)
	(supports instrument1 spectrograph2)
	(supports instrument1 infrared3)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 GroundStation4)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star13)
)
(:goal (and
	(have_image Planet12 spectrograph1)
	(have_image Planet12 infrared3)
	(have_image Star13 spectrograph2)
	(have_image Star13 infrared3)
	(have_image Phenomenon14 spectrograph1)
	(have_image Phenomenon14 spectrograph2)
	(have_image Phenomenon15 spectrograph1)
))

)
