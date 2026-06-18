(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	infrared3 - mode
	infrared5 - mode
	thermograph4 - mode
	spectrograph2 - mode
	spectrograph6 - mode
	spectrograph0 - mode
	spectrograph1 - mode
	Star0 - direction
	Star1 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star9 - direction
	Star10 - direction
	GroundStation12 - direction
	Star2 - direction
	GroundStation8 - direction
	GroundStation11 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 spectrograph6)
	(supports instrument0 infrared5)
	(supports instrument0 spectrograph2)
	(supports instrument0 thermograph4)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation12)
	(supports instrument1 spectrograph0)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 GroundStation11)
	(calibration_target instrument1 GroundStation8)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star6)
)
(:goal (and
	(have_image Phenomenon13 infrared5)
	(have_image Phenomenon14 spectrograph2)
	(have_image Star15 thermograph4)
	(have_image Star15 infrared3)
	(have_image Phenomenon16 infrared3)
))

)
