(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image3 - mode
	infrared2 - mode
	spectrograph1 - mode
	infrared0 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	Star8 - direction
	Phenomenon12 - direction
	Star13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 infrared0)
	(supports instrument0 spectrograph1)
	(supports instrument0 image3)
	(calibration_target instrument0 Star8)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star13)
)
(:goal (and
	(pointing satellite0 Star13)
	(have_image Phenomenon12 spectrograph1)
	(have_image Star13 image3)
	(have_image Phenomenon14 spectrograph1)
	(have_image Phenomenon15 infrared2)
))

)
