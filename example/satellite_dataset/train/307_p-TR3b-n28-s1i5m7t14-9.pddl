(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	image5 - mode
	spectrograph6 - mode
	infrared2 - mode
	infrared0 - mode
	thermograph4 - mode
	spectrograph1 - mode
	image3 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation7 - direction
	Star8 - direction
	Star12 - direction
	Star13 - direction
	Star9 - direction
	GroundStation10 - direction
	Star6 - direction
	Star11 - direction
	Star14 - direction
	Planet15 - direction
	Star16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 image3)
	(supports instrument0 spectrograph6)
	(supports instrument0 infrared0)
	(supports instrument0 infrared2)
	(supports instrument0 image5)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 Star9)
	(supports instrument1 thermograph4)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 Star11)
	(calibration_target instrument1 Star6)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
)
(:goal (and
	(pointing satellite0 GroundStation10)
	(have_image Star14 spectrograph1)
	(have_image Star14 thermograph4)
	(have_image Planet15 infrared0)
	(have_image Star16 infrared0)
	(have_image Star16 infrared2)
	(have_image Phenomenon17 spectrograph1)
	(have_image Phenomenon17 image5)
))

)
