(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	spectrograph1 - mode
	infrared5 - mode
	infrared3 - mode
	thermograph4 - mode
	spectrograph2 - mode
	spectrograph0 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation4 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	GroundStation10 - direction
	GroundStation2 - direction
	Star5 - direction
	GroundStation3 - direction
	Planet14 - direction
	Planet15 - direction
	Phenomenon16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph4)
	(supports instrument0 infrared3)
	(calibration_target instrument0 GroundStation10)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon16)
	(supports instrument1 spectrograph2)
	(supports instrument1 infrared5)
	(supports instrument1 spectrograph1)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation3)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 GroundStation2)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation2)
)
(:goal (and
	(have_image Planet14 spectrograph1)
	(have_image Planet15 spectrograph2)
	(have_image Planet15 spectrograph0)
	(have_image Phenomenon16 spectrograph0)
	(have_image Phenomenon16 spectrograph1)
	(have_image Star17 infrared5)
))

)
